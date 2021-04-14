defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  # * This also works (last part is taken as alias)
  # alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")
    [request_line | _headers] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    %Conv{
      method: method,
      path: path,
      params: parse_params(body)
    }
    |> parse_method
  end

  defp parse_params(params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
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
