defmodule Servy.Conv do
  defstruct [ method: "",
              path: "",
              status_code: "",
              resp_body: "",
              content_type: "text/html",
              params: %{},
              headers: %{} ]

  def full_response(conv) do
    "#{conv.status_code} #{status_reason(conv.status_code)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
