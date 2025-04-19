defmodule Servy.Plugins do
  @moduledoc """
  A module for plugins for Servy.
  """

  require Logger

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  @doc """
  Logs a request.
  """
  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      IO.inspect(conv)
    end

    conv
  end

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      Logger.warning("404 for #{path}")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv
end
