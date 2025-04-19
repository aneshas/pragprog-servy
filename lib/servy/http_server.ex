defmodule Servy.HttpServer do
  def start_link(port) when is_integer(port) and port > 1023 do
    spawn(fn -> start(port) end)
  end

  def start(port) when is_integer(port) and port > 1023 do
    {:ok, lsock} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("\n🎧  Listening for connection requests on port #{port}...\n")

    accept_loop(lsock)

    :gen_tcp.close(lsock)
  end

  defp accept_loop(lsock) do
    IO.puts("⌛️  Waiting to accept a client connection...\n")

    {:ok, sock} = :gen_tcp.accept(lsock)

    IO.puts("⚡️  Connection accepted!\n")

    spawn(fn -> serve(sock) end)

    accept_loop(lsock)
  end

  defp serve(sock) do
    IO.inspect(" #{inspect(self())}: working on it...")

    {:ok, req} = :gen_tcp.recv(sock, 0)

    response = Servy.Handler.handle(req)

    :ok = :gen_tcp.send(sock, response)

    :ok = :gen_tcp.close(sock)
  end
end
