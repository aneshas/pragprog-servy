defmodule Servy.Api.BearController do
  alias Servy.Bear
  alias Servy.Wildthings

  def list(conv, _params) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly?/1)
      |> Enum.sort(&Bear.order_by_name_asc/2)
      |> Poison.encode!()

    %{conv | status: 200, resp_content_type: "application/json", resp_body: bears}
  end
end
