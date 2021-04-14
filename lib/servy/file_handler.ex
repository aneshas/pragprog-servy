defmodule Servy.FileHandler do
  def handle_file({:ok, contents}) do
    {200, contents}
  end

  def handle_file({:error, :enoent}) do
    {404, "File not found!"}
  end

  def handle_file({:error, reason}) do
    {500, :file.format_error(reason)}
  end
end
