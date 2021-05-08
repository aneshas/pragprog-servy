defmodule Servy.StaticServer do
  alias Servy.Conv

  import Servy.FileHandler

  # * Values for attributes are set at compile time"
  @pages_path Path.expand("../../pages", __DIR__)

  def serve_static_files(file, %Conv{} = conv) do
    {code, response} =
      @pages_path
      |> Path.join("#{file}.html")
      |> File.read()
      |> handle_file

    %{conv | status: code, resp_body: response}
  end
end
