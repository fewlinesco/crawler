defmodule Crawler.Worker do
  use GenServer

  defstruct supervisor_pid: nil

  # Client

  def start_link(options \\ []) do
    state = %Crawler.Worker{supervisor_pid: self()}

    GenServer.start_link(Crawler.Worker, state, options)
  end

  def crawl(pid, on_update) do
    GenServer.cast(pid, {:crawl, on_update})
  end

  # Server

  def handle_cast({:crawl, callback}, state) do
    fetch_batch_of_urls(state.supervisor_pid, callback)

    {:noreply, state}
  end

  # Utils

  defp do_fetch_url(supervisor_pid, url, callback) do
    children_urls = Crawler.Supervisor.find_urls(supervisor_pid, url)

    Crawler.Supervisor.add_visit(supervisor_pid, url, children_urls)

    callback.({:link_found, url, children_urls})
  end

  defp fetch_batch_of_urls(supervisor_pid, callback) do
    case Crawler.Supervisor.next_batch_of_urls(supervisor_pid) do
      [] ->
        :ok
      urls ->
        urls
        |> Enum.map(fn url -> fetch_url(supervisor_pid, url, callback) end)
        |> Enum.map(fn fetcher_pid -> await_fetcher(fetcher_pid) end)

        fetch_batch_of_urls(supervisor_pid, callback)
    end
  end

  defp fetch_url(supervisor_pid, url, callback) do
    Task.async(fn -> do_fetch_url(supervisor_pid, url, callback) end)
  end

  defp await_fetcher(fetcher_pid) do
    # We wait the fetcher for 10 seconds. If the page does not come back
    # it will throw an exception. Here we just chose to discard it.
    try do
      Task.await(fetcher_pid, 10_000)
    rescue
      _error -> nil
    end
  end
end
