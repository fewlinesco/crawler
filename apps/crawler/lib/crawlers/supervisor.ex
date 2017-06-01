defmodule Crawlers.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: Crawlers.Supervisor)
  end

  def init([]) do
    children = [
      worker(Registry, [:unique, Crawlers.Registry]),
      supervisor(Crawlers.Children, [], id: ChildrenSupervisor)
    ]

    supervise(children, strategy: :one_for_all)
  end

  def crawl(root_url, fetchers_count, on_update) do
    case start_crawler(root_url, fetchers_count) do
      {:ok, pid} ->
        Crawler.Supervisor.crawl(pid, on_update)

        {:ok, pid}
      error ->
        raise error
    end
  end

  def stop(root_url) do
    root_url
    |> crawler_pid()
    |> Crawler.Supervisor.stop
  end

  defp children_supervisor_pid(pid) do
    matching_supervisor = fn
      {ChildrenSupervisor, supervisor_pid, _type, _modules} ->
        supervisor_pid
      _ ->
        nil
    end

    pid
    |> Supervisor.which_children()
    |> Enum.find_value(matching_supervisor)
  end

  defp crawler_name(root_url) do
    {:via, Registry, {Crawlers.Registry, root_url}}
  end

  defp crawler_pid(root_url) do
    case Registry.lookup(Crawlers.Registry, root_url) do
      [] ->
        nil
      [{pid, _}] ->
        pid
    end
  end

  defp start_crawler(root_url, fetchers_count) do
    Crawlers.Supervisor
    |> children_supervisor_pid()
    |> Crawlers.Children.start_child(root_url, fetchers_count, crawler_name(root_url))
  end
end
