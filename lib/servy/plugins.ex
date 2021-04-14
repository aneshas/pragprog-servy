defmodule Servy.Plugins do
  require Logger

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings "}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log_request(%Conv{} = conv) do
    Logger.info("A request came in: #{inspect(conv)}")
    conv
  end

  def emojify(%Conv{status: 200} = conv), do: %{conv | resp_body: "😎 #{conv.resp_body} 😎"}

  def emojify(%Conv{} = conv), do: conv
end
