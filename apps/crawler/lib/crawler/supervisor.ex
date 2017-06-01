defmodule Crawler.Supervisor do
  use Supervisor

  def start_link(root_url, fetchers_count, options) do
    Supervisor.start_link(__MODULE__, {root_url, fetchers_count}, options)
  end

  def init({root_url, fetchers_count}, adapter \\ HTTPoison) do
    children = [
      worker(Crawler.History, [root_url, fetchers_count], id: History),
      worker(Crawler.Worker, [], id: Worker),
      supervisor(:poolboy, [[worker_module: Crawler.Fetcher, size: fetchers_count, max_overflow: 2], adapter], id: Fetchers)
    ]

    supervise(children, strategy: :rest_for_one)
  end

  def add_visit(supervisor_pid, url, children_urls) do
    Crawler.History.add_visit(find_worker(supervisor_pid, History), url, children_urls)
  end

  def crawl(supervisor_pid, on_update) do
    Crawler.Worker.crawl(find_worker(supervisor_pid, Worker), on_update)
  end

  def find_urls(supervisor_pid, url) do
    :poolboy.transaction(find_worker(supervisor_pid, Fetchers), fn pid ->
      Crawler.Fetcher.find_urls(pid, url)
    end)
  end

  def next_urls(supervisor_pid) do
    Crawler.History.next_urls(find_worker(supervisor_pid, History))
  end

  def page_from_history(supervisor_pid, url) do
    Crawler.History.page(find_worker(supervisor_pid, History), url)
  end

  def stop(supervisor_pid) do
    Supervisor.stop(supervisor_pid)
  end

  defp find_worker(pid, worker_identifier) do
    matching_worker = fn
      {^worker_identifier, worker_pid, _type, _modules} ->
        worker_pid
      _ ->
        nil
    end

    pid
    |> Supervisor.which_children()
    |> Enum.find_value(matching_worker)
  end
end
