defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of headers into a map" do
    headers = ["A: foo", "B: bar", "Abc-Def: baz"]

    got = Parser.parse_headers(headers)

    assert got == %{A: "foo", B: "bar", "Abc-Def": "baz"}
  end
end
