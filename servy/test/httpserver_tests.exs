defmodule HttpServerTests do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    pid = spawn(HttpServer, :start, [4000])

    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)
    Process.exit(pid, :kill)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 50\r
    \r
    Bears, Lions, Tigers, Dookie, Nöödle, and Mookie
    """
  end

  test "Test the /about via spawned process." do
    pid = spawn(HttpServer, :start, [4000])

    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)
    Process.exit(pid, :kill)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 102\r
    \r
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>\n
    """
  end

end
