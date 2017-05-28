defmodule Crawler.Fetcher do
  use GenServer

  def start_link(adapter \\ HTTPoison) do
    GenServer.start_link(Crawler.Fetcher, adapter, [])
  end

  def find_urls(pid, url) do
    GenServer.call(pid, {:find_urls, url})
  end

  def handle_call({:find_urls, url}, _from, adapter) do
    children =
      url
      |> Fetcher.get(adapter)
      |> normalize_fetching_result()
      |> Parser.find_links(url)

    {:reply, children, adapter}
  end

  defp normalize_fetching_result({:ok, body}) do
    body
  end
  defp normalize_fetching_result(_error) do
    ""
  end
end
