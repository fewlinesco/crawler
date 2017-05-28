defmodule Crawler.Worker do
  use GenServer

  def start_link(root_url, options \\ []) do
    GenServer.start_link(Crawler.Worker, root_url, options)
  end

  def crawl(pid, on_update) do
    GenServer.cast(pid, {:crawl, on_update})
  end

  def handle_cast({:crawl, callback}, root_url) do
    fetch(root_url, callback)

    {:noreply, root_url}
  end

  defp do_fetch(root_url, url, callback) do
    children_urls = Crawlers.Supervisor.find_urls(root_url, url)

    Crawlers.Supervisor.add_visit(root_url, url, children_urls)

    callback.({:link_found, url, children_urls})
  end

  defp fetch(root_url, callback) do
    case Crawlers.Supervisor.next_urls(root_url) do
      [] ->
        :ok
      urls ->
        asynchronous_fetch = fn url ->
          Task.async(fn -> do_fetch(root_url, url, callback) end)
        end

        urls
        |> Enum.map(asynchronous_fetch)
        |> Enum.map(&Task.await/1)

        fetch(root_url, callback)
    end
  end
end
