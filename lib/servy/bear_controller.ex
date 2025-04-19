defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Wildthings
  alias Servy.BearView

  def list(conv, _params) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly?/1)
      |> Enum.sort(&Bear.order_by_name_asc/2)

    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def create(conv, %{"name" => name, "type" => _type}) do
    %{conv | status: 200, resp_body: "Bear #{name} created"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.find_bear(id)

    %{conv | status: 200, resp_body: BearView.show(bear)}
  end
end

defmodule Servy.BearView do
  require EEx

  @templates_path Path.expand("../../templates", __DIR__)

  EEx.function_from_file(:def, :index, Path.join(@templates_path, "list.eex"), [:bears])

  EEx.function_from_file(:def, :show, Path.join(@templates_path, "show.eex"), [:bear])
end
