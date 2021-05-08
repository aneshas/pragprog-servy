defmodule Servy.Router do
  alias Servy.Conv
  alias Servy.Wildthings

  import Servy.StaticServer, only: [serve_static_files: 2]
  import Servy.Template, only: [parse: 2]

  @doc """
  Static files are served first.
  Api's after that.
  Finally if no route is matched 404 is returned.
  """
  def route(%Conv{method: :get, path: "/pages/" <> file} = conv) do
    serve_static_files(file, conv)
  end

  def route(%Conv{method: :get, path: "/wildthings"} = conv),
    do: %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}

  def route(%Conv{method: :get, path: "/bears"} = conv) do
    bears = Wildthings.list_bears()

    %{conv | status: 200, resp_body: parse("index", bears: bears)}
  end

  def route(%Conv{method: :get, path: "/bears/" <> id} = conv),
    do: %{conv | status: 200, resp_body: "A bear with an id of #{id}"}

  def route(%Conv{method: :post, path: "/bears", params: params} = conv) do
    %{
      conv
      | status: 201,
        resp_body: "A bear was created #{params["name"]} - #{params["type"]}"
    }
  end

  def route(%Conv{method: :delete, path: "/bears/" <> _id} = conv),
    do: %{conv | status: 403, resp_body: "Bears must never be deleted!"}

  def route(%Conv{method: method, path: path} = conv) do
    msg = "No matching handler: [#{method}] #{path}"
    %{conv | status: 404, resp_body: msg}
  end
end
