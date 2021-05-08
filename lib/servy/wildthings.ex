defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: false},
      %Bear{id: 1, name: "Smokey", type: "Black", hibernating: true}
    ]
  end
end
