defmodule Crawler.History do
  use GenServer

  defstruct root_url: nil, visited_pages: %{}, to_visits: nil, batch_size: nil

  def start_link(root_url, batch_size, options \\ []) do
    GenServer.start_link(Crawler.History, create_state(root_url, batch_size), options)
  end

  def add_visit(pid, url, children_urls) do
    GenServer.call(pid, {:add_visit, {url, children_urls}})
  end

  def next_batch_of_urls(pid) do
    GenServer.call(pid, :next_batch_of_urls)
  end

  def page(pid, url) do
    GenServer.call(pid, {:page, url})
  end

  def handle_call({:add_visit, page}, _from, state) do
    new_state =
      state
      |> update_visited_pages(page)
      |> update_to_visits(page)

    {:reply, :ok, new_state}
  end
  def handle_call(:next_batch_of_urls, _from, state) do
    {urls, updated_to_visits} = Queue.remove(state.to_visits, state.batch_size)

    {:reply, urls, put_to_visits(state, updated_to_visits)}
  end
  def handle_call({:page, url}, _from, state) do
    {:reply, Map.get(state.visited_pages, url), state}
  end

  defp create_state(root_url, batch_size) do
    %Crawler.History{root_url: root_url, to_visits: Queue.new(root_url), batch_size: batch_size}
  end

  defp put_to_visits(state, to_visits) do
    %Crawler.History{state | to_visits: to_visits}
  end

  defp update_visited_pages(state, {url, children_urls}) do
    updated_visited_pages = Map.put(state.visited_pages, url, children_urls)

    %Crawler.History{state | visited_pages: updated_visited_pages}
  end

  defp update_to_visits(state, {_url, children_urls}) do
    urls = Enum.reject(children_urls, fn url -> Map.has_key?(state.visited_pages, url) end)

    put_to_visits(state, Queue.add_new(state.to_visits, urls))
  end
end
