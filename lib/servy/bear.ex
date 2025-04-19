defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly?(%__MODULE__{type: type}) do
    type == "Grizzly"
  end

  def order_by_name_asc(l, r) do
    l.name < r.name
  end
end
