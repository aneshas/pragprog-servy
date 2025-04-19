defmodule Servy.Handler do
  @moduledoc """
  A handler for Servy.
  """

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam
  alias Servy.Api.BearController, as: ApiBearController

  @pages_dir Path.expand("pages", File.cwd!())

  @doc """
  Handles a request.
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> route()
    |> track()
    |> log()
    |> format_response()
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    snapshots =
      ["cam1", "cam2", "cam3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await(&1, :timer.seconds(10)))

    template =
      Path.expand("../../templates", __DIR__)
      |> Path.join("sensors.eex")
      |> EEx.eval_file(snapshots: snapshots)

    %{conv | status: 200, resp_body: template}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/hibernate"} = conv) do
    :timer.sleep(5000)

    %{conv | status: 200, resp_body: "Awake..."}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.list(conv, %{})
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    read_file(conv, "form.html")
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    ApiBearController.list(conv, %{})
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    read_file(conv, "about.html")
  end

  def route(%Conv{method: "GET", path: "/not_found"} = conv) do
    read_file(conv, "not_found.html")
  end

  def route(%Conv{method: method, path: path} = conv) do
    %{
      conv
      | resp_body: "No route found for #{method} #{path}",
        status: 404
    }
  end

  defp read_file(%Conv{} = conv, file) do
    @pages_dir
    |> Path.join(file)
    |> File.read()
    |> handle_file(conv)
  end

  defp handle_file({:ok, body}, conv), do: %{conv | status: 200, resp_body: body}

  defp handle_file({:error, :enoent}, conv),
    do: %{conv | status: 404, resp_body: "File not found"}

  defp handle_file({:error, _}, conv),
    do: %{conv | status: 500, resp_body: "Internal server error"}

  def format_response(conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv.status)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
