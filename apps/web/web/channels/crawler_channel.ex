defmodule Web.CrawlerChannel do
  use Phoenix.Channel

  def join("crawler:new", _message, socket) do
    {:ok, socket}
  end

  def handle_in("stop", _payload, socket) do
    Crawlers.Supervisor.stop(socket.assigns[:url])

    push(socket, "stopped", %{})

    {:noreply, socket}
  end

  def handle_in("crawl", %{"url" => url, "power" => fetchers_count}, socket) do
    new_socket = assign(socket, :url, url)

    Crawlers.Supervisor.crawl(url, fetchers_count, fn {:link_found, url, children_urls} ->
      push(new_socket, "link_found", %{url: url, children: children_urls})
    end)

    {:noreply, new_socket}
  end
end
