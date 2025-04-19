defmodule Servy.Parser do
  @moduledoc """
  A parser for Servy.
  """

  alias Servy.Conv

  def parse(request) do
    [top, bottom] = String.split(request, "\r\n\r\n", parts: 2)

    [head | header_lines] = String.split(top, "\r\n")

    headers = parse_headers(header_lines)

    [method, path, _] = String.split(head, " ")

    params = parse_params(headers["Content-Type"], bottom)

    %Conv{
      method: String.upcase(method),
      status: nil,
      path: path,
      resp_body: "",
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    header_lines
    |> Enum.reduce(%{}, fn header, acc ->
      [key, value] = String.split(header, ": ", parts: 2)
      Map.put(acc, String.trim(key), String.trim(value))
    end)
  end

  def parse_params("application/x-www-form-urlencoded" = _content_type, body) do
    body
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
