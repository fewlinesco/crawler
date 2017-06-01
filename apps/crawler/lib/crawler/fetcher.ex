defmodule Crawler.Fetcher do
  use GenServer

  defstruct adapter: nil

  # Client

  def start_link(adapter \\ HTTPoison) do
    state = %Crawler.Fetcher{adapter: adapter}

    GenServer.start_link(Crawler.Fetcher, state, [])
  end

  def find_urls(pid, url) do
    GenServer.call(pid, {:find_urls, url}, 20_000)
  end

  # Server

  def handle_call({:find_urls, url}, _from, state) do
    children =
      url
      |> Fetcher.get(state.adapter)
      |> normalize_fetching_result()
      |> Parser.find_links(url)

    {:reply, children, state}
  end

  # Utils

  defp normalize_fetching_result({:ok, body}) do
    body
  end
  defp normalize_fetching_result(_error) do
    ""
  end
end
