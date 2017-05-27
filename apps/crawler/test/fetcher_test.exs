defmodule FetcherTest do
  use ExUnit.Case

  defmodule TestAdapter do
    def get("https://current.com/page") do
      {:ok, %HTTPoison.Response{body: "<p>Hello World</p>",
                                status_code: 200,
                                headers: [{"Content-Type", "text/html"}]}}
    end

    def get("https://current.com/utf8-page") do
      {:ok, %HTTPoison.Response{body: "<p>Hello World</p>",
                                status_code: 200,
                                headers: [{"Content-Type", "text/html; charset=utf-8"}]}}
    end

    def get("https://current.com/page.json") do
      {:ok, %HTTPoison.Response{body: ~s({"message": "Hello World"}),
                                status_code: 200,
                                headers: [{"Content-Type", "application/json"}]}}
    end

    def get("https://current.com/invalid") do
      {:ok, %HTTPoison.Response{body: "<p>Page not found</p>",
                                status_code: 404,
                                headers: [{"Content-Type", "text/html"}]}}
    end

    def get("https://current.com/error") do
      {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}
    end
  end

  test "get: when url is a valid HTML page" do
    url = "https://current.com/page"

    assert {:ok, "<p>Hello World</p>"} == Fetcher.get(url, TestAdapter)
  end

  test "get: when url is a valid utf8 HTML page" do
    url = "https://current.com/utf8-page"

    assert {:ok, "<p>Hello World</p>"} == Fetcher.get(url, TestAdapter)
  end

  test "get: when url is a valid JSON page" do
    url = "https://current.com/page.json"

    assert {:error, :wrong_content_type} == Fetcher.get(url, TestAdapter)
  end

  test "get: when url is an invalid HTML page" do
    url = "https://current.com/invalid"

    assert {:error, :invalid_status_code} == Fetcher.get(url, TestAdapter)
  end

  test "get: when website is not available" do
    url = "https://current.com/error"

    assert {:error, :econnrefused} == Fetcher.get(url, TestAdapter)
  end
end
