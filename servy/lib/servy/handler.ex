defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests."

  import Servy.Router, only: [route: 1]
  import Servy.Plugins, only: [log: 1, rewrite_path: 1, track: 1]

  alias Servy.Conv

  @doc "Transforms the request into a response."
  def handle(request) do
    request
      |> parse
      |> log
      |> rewrite_path
      |> route
      |> track
      |> format_response
  end

  @doc """
  Parses request into smaller parts.
  """
  def parse(request) do
    [top, params] = request |> String.split("\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})

    params_decoded = parse_params(headers["Content-Type"], params)

    %Conv{  method: method,
            path: path,
            status_code: "",
            resp_body: "",
            params: params_decoded,
            headers: headers }
  end

  def parse_params(params) do
    params |> String.trim |> URI.decode_query
  end

  def parse_params("application/x-www-form-urlencoded", params) do
    params |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Servy.Conv.full_response(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /cock HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wildthings?id=5 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/6 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Lenght: 21

name=Baloo&type=Brown
"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Lenght: 21

name=Baloo&type=Brown
"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Lenght: 21

name=Baloo&type=Brown
"""
response = Servy.Handler.handle(request)
IO.puts response
