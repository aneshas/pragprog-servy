defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  # * This also works (last part is taken as alias)
  # alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    %Conv{
      method: method,
      path: path,
      params: parse_params(body, headers["Content-Type"]),
      headers: headers
    }
    |> parse_method
  end

  defp parse_params(params_string, "application/x-www-form-urlencoded") do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  defp parse_params(_, _), do: %{}

  def parse_headers(headers) do
    headers
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.reduce(%{}, fn [k, v], acc -> Map.put(acc, String.to_atom(k), v) end)
  end

  defp parse_method(%Conv{} = conv) do
    method =
      %{
        "GET" => :get,
        "POST" => :post,
        "DELETE" => :delete
      }[conv.method]

    %{conv | method: method}
  end
end
