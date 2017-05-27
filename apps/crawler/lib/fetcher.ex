defmodule Fetcher do
  require Logger

  def get(url, adapter \\ HTTPoison) do
    Logger.info("Fetch #{url}")

    url
    |> adapter.get
    |> ensure_fetched()
    |> ensure_html()
    |> fetch_body()
  end

  defp ensure_fetched({:ok, response = %HTTPoison.Response{status_code: 200}}) do
    {:ok, response}
  end
  defp ensure_fetched({:ok, _wrong_status_code_response}) do
    {:error, :invalid_status_code}
  end
  defp ensure_fetched({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp ensure_html({:ok, response = %HTTPoison.Response{headers: headers}}) do
    Enum.find_value(headers, {:error, :wrong_content_type}, fn
      {"Content-Type", "text/html" <> _any_encoding} -> {:ok, response}
      _ -> nil
    end)
  end
  defp ensure_html(error) do
    error
  end

  defp fetch_body({:ok, response}) do
    {:ok, response.body}
  end
  defp fetch_body(error) do
    error
  end
end
