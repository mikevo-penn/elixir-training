defmodule HttpServerTests do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  # Globally spawn the expected http server on port 4000
  pid = spawn(HttpServer, :start, [4000])

  test "requests and responses via HttPoison" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie"
  end

  test "multiple concurrent requests" do
    parent = self()

    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"
        send(parent, {:okzz, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:okzz, response} ->
        assert response.status_code == 200
        assert response.body == "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie"
      end
    end
  end

  test "accepts a request on a socket and sends back a response" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

    assert response.body == "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie"
  end

  test "Test the /about via spawned process." do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)

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
