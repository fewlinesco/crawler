defmodule Crawlers.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: Crawlers.Supervisor)
  end

  def init([]) do
    children = [
      worker(Registry, [:unique, Crawlers.Registry])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def add_visit(root_url, url, children_urls) do
    root_url
    |> supervisor_pid()
    |> Crawler.Supervisor.add_visit(url, children_urls)
  end

  def crawl(root_url, on_update) do
    case Supervisor.start_child(Crawlers.Supervisor, crawler_spec(root_url)) do
      {:ok, pid} ->
        Crawler.Supervisor.crawl(pid, on_update)

        {:ok, pid}
      error ->
        error
    end
  end

  def find_urls(root_url, url) do
    root_url
    |> supervisor_pid()
    |> Crawler.Supervisor.find_urls(url)
  end

  def next_urls(root_url) do
    root_url
    |> supervisor_pid()
    |> Crawler.Supervisor.next_urls
  end

  def page_from_history(root_url, url) do
    root_url
    |> supervisor_pid()
    |> Crawler.Supervisor.page_from_history(url)
  end

  def stop(root_url) do
    root_url
    |> supervisor_pid()
    |> Crawler.Supervisor.stop
  end

  defp crawler_spec(root_url) do
    supervisor(Crawler.Supervisor, [root_url, [name: crawler_name(root_url)]])
  end

  defp crawler_name(root_url) do
    {:via, Registry, {Crawlers.Registry, root_url}}
  end

  defp supervisor_pid(root_url) do
    case Registry.lookup(Crawlers.Registry, root_url) do
      [] ->
        nil
      [{pid, _}] ->
        pid
    end
  end
end
