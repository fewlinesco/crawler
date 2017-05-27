defmodule ParserTest do
  use ExUnit.Case

  test "find_links: returns all links in the page when some are present" do
    html = """
    <html>
      <head>
        <title>The page</title>
      </head>
      <body>
        <p>Some text with a <a href="/other/page">link to another page</a>.</p>
        <p>I might also add a <a href="https://othersite.com/page">link to an external site</a>.</p>
        <p>And maybe a <a href="//asite.com/page2">protocol relative URL</a>.</p>
        <p>And finally a tel link <a href="tel://0192837465">Call US</a>.</p>
      </body>
    </html>
    """
    current_uri = "https://current.com/home"
    expected_urls = ["https://current.com/other/page", "https://othersite.com/page", "https://asite.com/page2"]

    assert expected_urls == Parser.find_links(html, current_uri)
  end

  test "find_links: returns an empty array when no links are found" do
    html = """
    <html>
      <head>
        <title>The page</title>
      </head>
      <body>
        <p>Some text without a link.</p>
        <p>Not even an external link.</p>
      </body>
    </html>
    """
    current_uri = "https://current.com/"
    expected_urls = []

    assert expected_urls == Parser.find_links(html, current_uri)
  end
end
