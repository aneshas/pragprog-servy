defmodule ServyHandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  import Servy.Handler, only: [handle: 1]

  test "can get bears" do
    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    want = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 35

    😎 Teddy, Smokey, Paddington 😎
    """

    assert handle(request) == want
  end

  # test "can get a specific bear"
end
