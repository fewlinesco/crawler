defmodule Crawler.Worker do
  use GenServer

  def start_link(options \\ []) do
    GenServer.start_link(Crawler.Worker, self(), options)
  end

  def crawl(pid, on_update) do
    GenServer.cast(pid, {:crawl, on_update})
  end

  def handle_cast({:crawl, callback}, supervisor_pid) do
    fetch(supervisor_pid, callback)

    {:noreply, supervisor_pid}
  end

  defp do_fetch(supervisor_pid, url, callback) do
    children_urls = Crawler.Supervisor.find_urls(supervisor_pid, url)

    Crawler.Supervisor.add_visit(supervisor_pid, url, children_urls)

    callback.({:link_found, url, children_urls})
  end

  defp fetch(supervisor_pid, callback) do
    case Crawler.Supervisor.next_urls(supervisor_pid) do
      [] ->
        :ok
      urls ->
        asynchronous_fetch = fn url ->
          Task.async(fn -> do_fetch(supervisor_pid, url, callback) end)
        end

        await_safely = fn pid ->
          try do
            Task.await(pid, 10_000)
          rescue
            error -> nil
          end
        end

        urls
        |> Enum.map(asynchronous_fetch)
        |> Enum.map(await_safely)

        fetch(supervisor_pid, callback)
    end
  end
end
