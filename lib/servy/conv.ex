defmodule Servy.Conv do
  # Struct is internall a special case of a map

  # Remember this is a keyword list and is shorthanded
  # eg. it should have [] around, but since it is the last
  # argument to the macro brackets can be omited
  # keyword list is just a syntacsic shugar for list of tuples
  # where first item is an atom and second a value
  # Comonly used for a list of options (or defining structs like here)
  defstruct method: "",
            path: "",
            resp_body: "",
            status: nil,
            params: %{}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      403 => "Forbidden",
      404 => "Not Found"
    }[code]
  end
end
