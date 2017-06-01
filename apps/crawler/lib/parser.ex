defmodule Parser do
  def find_links(page, current_url) do
    page
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.map(fn href -> URI.parse(href) end)
    |> Enum.filter(fn uri -> valid_uri?(uri) end)
    |> Enum.map(fn uri -> build_url(uri, current_url) end)
  end

  def build_url(uri = %URI{host: host}, current_url) when not is_nil(host) do
    uri
    |> put_scheme(current_url)
    |> discard_fragments()
    |> URI.to_string
  end
  def build_url(uri, current_url) do
    current_url
    |> URI.parse
    |> URI.merge(uri)
    |> discard_fragments()
    |> URI.to_string
  end

  def valid_uri?(%URI{scheme: scheme}) when scheme in ["http", "https", nil] do
    true
  end
  def valid_uri?(_uri) do
    false
  end

  defp discard_fragments(uri) do
    %URI{uri | fragment: nil}
  end

  defp put_scheme(uri = %URI{scheme: nil}, current_url) do
    current_uri = URI.parse(current_url)

    %{uri | scheme: current_uri.scheme}
  end
  defp put_scheme(uri, _current_url) do
    uri
  end
end
