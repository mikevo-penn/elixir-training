defmodule HandlerTests do
  use ExUnit.Case
  doctest Servy.Handler
  alias Servy.Handler

  test "Parse params for urlencoded parameters aka application/x-www-form-urlencoded" do
    conv = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Baloo&type=Brown
    """

    [top, params] = conv |> String.split("\n\n")
    [_ | header_lines] = String.split(top, "\n")
    headers = Handler.parse_headers(header_lines, %{})
    response = Handler.parse_params(headers["Content-Type"], params)

    assert response == %{"name" => "Baloo", "type" => "Brown"}
  end


  test "Parse params does nothing for non urlencoded parameters aka Content-Type: text" do
    conv = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: text
    Content-Length: 21

    name=Baloo&type=Brown
    """

    [top, params] = conv |> String.split("\n\n")
    [_ | header_lines] = String.split(top, "\n")
    headers = Handler.parse_headers(header_lines, %{})
    response = Handler.parse_params(headers["Content-Type"], params)

    assert response == %{}
  end
end
