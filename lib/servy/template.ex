defmodule Servy.Template do
  @templates_path Path.expand("../../templates", __DIR__)

  def parse(tpl, data) do
    @templates_path
    |> Path.join("#{tpl}.eex")
    |> EEx.eval_file(data)
  end
end
