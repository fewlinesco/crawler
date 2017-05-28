defmodule Crawler.FetcherTest do
  use ExUnit.Case

  defmodule TestAdapter do
    def get("https://current.com") do
      html = """
      <p>
        Some text with an <a href="/my-page">internal link</a> and
        event an other <strong>link to <a href="https://anothersite.com/page">another site</a></strong>
      </p>
      """

      {:ok, %HTTPoison.Response{body: html, status_code: 200, headers: [{"Content-Type", "text/html"}]}}
    end
  end

  test "fetch: when URL contains links" do
    {:ok, pid} = Crawler.Fetcher.start_link(TestAdapter)

    expected_children = ["https://current.com/my-page", "https://anothersite.com/page"]

    assert expected_children == Crawler.Fetcher.find_urls(pid, "https://current.com")
  end
end
