defmodule ServyHandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  @wildlife_resp """
  HTTP/1.1 200 OK\r
  Content-Type: text/html\r
  Content-Length: 20\r
  \r
  Bears, Lions, Tigers
  """

  test "GET /wildthings" do
    resp = handle(request("GET", "/wildthings"))

    assert resp == @wildlife_resp
  end

  test "GET /wildlife" do
    resp = handle(request("GET", "/wildlife"))

    assert resp == @wildlife_resp
  end

  test "GET /bears" do
    resp = handle(request("GET", "/bears"))

    want = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 114\r
    \r
    <ul>

    <li>Brutus - Grizzly</li>

    <li>Kenai - Grizzly</li>

    <li>Scarface - Grizzly</li>

    </ul>

    """

    assert remove_whitespace(resp) == remove_whitespace(want)
  end

  test "GET /bears/:id" do
    resp = handle(request("GET", "/bears/5"))

    assert resp == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 34\r
           \r
           Is <b>Snow</b> hibernating? false

           """
  end

  test "GET /bigfoot" do
    resp = handle(request("GET", "/bigfoot"))

    assert resp == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 31\r
           \r
           No route found for GET /bigfoot
           """
  end

  test "GET /about" do
    resp = handle(request("GET", "/about"))

    want = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 46\r
    \r
    <h1>About</h1>
    <p>This is the about page.</p>

    """

    assert remove_whitespace(resp) == remove_whitespace(want)
  end

  test "GET /not_found" do
    resp = handle(request("GET", "/not_found"))

    assert resp == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 14\r
           \r
           File not found
           """
  end

  test "GET /bears/new" do
    resp = handle(request("GET", "/bears/new"))

    want = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 240\r
    \r
    <form action="/bears" method="POST">
    <p>
    Name:<br />
    <input type="text" name="name" />
    </p>
    <p>
    Type:<br />
    <input type="text" name="type" />
    </p>
    <p>
    <input type="submit" value="Create Bear" />
    </p>
    </form>

    """

    assert remove_whitespace(resp) == remove_whitespace(want)
  end

  test "POST /bears" do
    resp = handle(request("POST", "/bears", "name=Teddy&type=Grizzly"))

    assert resp == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 18\r
           \r
           Bear Teddy created
           """
  end

  test "GET /api/bears" do
    resp = handle(request("GET", "/api/bears"))

    assert resp == """
           HTTP/1.1 200 OK\r
           Content-Type: application/json\r
           Content-Length: 188\r
           \r
           [{\"hibernating\":false,\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6},{\"hibernating\":false,\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10},{\"hibernating\":true,\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4}]
           """
  end

  defp request(method, path, body \\ "") do
    """
    #{method} #{path} HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    """
    |> content_headers(body)
    |> content(body)
  end

  defp content_headers(request, "" = _body), do: request

  defp content_headers(request, body) do
    """
    #{request}
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: #{byte_size(body)}\r
    """
  end

  defp content(request, "" = _body) do
    """
    #{request}\r
    \r
    """
  end

  defp content(request, body) do
    """
    #{request}\r
    \r
    #{body}
    """
  end

  defp remove_whitespace(string) do
    String.replace(string, " ", "")
  end
end
