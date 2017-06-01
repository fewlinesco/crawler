defmodule Crawler.HistoryTest do
  use ExUnit.Case

  test "add_visit: add new page to the history" do
    {:ok, pid} = Crawler.History.start_link("https://current.com", 10)

    first_children = ["https://current.com/page1", "https://current.com/page2"]
    Crawler.History.add_visit(pid, "https://current.com/", first_children)

    second_children = ["https://current.com/", "https://current.com/page3"]
    Crawler.History.add_visit(pid, "https://current.com/page1", second_children)

    assert first_children == Crawler.History.page(pid, "https://current.com/")
    assert second_children == Crawler.History.page(pid, "https://current.com/page1")
  end

  test "page: when page exists" do
    {:ok, pid} = Crawler.History.start_link("https://current.com", 10)

    children = ["https://current.com/page1", "https://current.com/page2"]
    Crawler.History.add_visit(pid, "https://current.com/", children)

    assert children == Crawler.History.page(pid, "https://current.com/")
  end

  test "page: when page doesn't exist" do
    {:ok, pid} = Crawler.History.start_link("https://current.com", 10)

    Crawler.History.add_visit(pid, "https://current.com/", ["https://current.com/page1", "https://current.com/page2"])

    assert nil == Crawler.History.page(pid, "https://other.com/")
  end

  test "next: when server starts" do
    {:ok, pid} = Crawler.History.start_link("https://current.com", 10)

    assert ["https://current.com"] == Crawler.History.next_batch_of_urls(pid)
  end

  test "next: when server has visited some pages" do
    root_url = "https://current.com"

    {:ok, pid} = Crawler.History.start_link(root_url, 10)

    first_children = ["https://current.com/page1", "https://current.com/page2"]
    Crawler.History.add_visit(pid, root_url, first_children)

    second_children = ["https://current.com", "https://current.com/page3"]
    Crawler.History.add_visit(pid, "https://current.com/page1", second_children)

    expected_urls = Enum.uniq([root_url] ++ first_children ++ second_children)

    assert expected_urls == Crawler.History.next_batch_of_urls(pid)
  end
end
