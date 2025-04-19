defmodule Servy.Conv do
  defstruct method: nil,
            path: "",
            status: "",
            resp_body: "",
            headers: %{},
            params: %{},
            resp_content_type: "text/html"

  @spec full_status(integer()) :: String.t()

  def full_status(status) do
    "#{status} #{status_reason(status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      418 => "I'm a teapot",
      500 => "Internal Server Error"
    }[code]
  end
end
