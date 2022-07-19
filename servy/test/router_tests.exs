defmodule RouterTests do
  use ExUnit.Case
  alias Servy.Router
  alias Servy.Handler
  alias Servy.Conv

  test "Test GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie"
  end

  test "Test GET /wildthings?{id}=8 where {id} is a number." do
    request = """
    GET /wildthings?id=8 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == """
    <h1>Show Bear</h1>
    <p>
        Is Roscoe 8 hibernating? <strong>false</strong>
    </p>
    """
  end

  test "Test GET /wildthings/{id} where {id} is a number." do
    request = """
    GET /wildthings/3 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == """
    <h1>Show Bear</h1>
    <p>
        Is Paddington 3 hibernating? <strong>false</strong>
    </p>
    """
  end

  test "Test GET /wildlife and re-write" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie"
  end


  test "Test GET /bears" do
    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body ==
    """
    <h1>All The Bears!</h1>

    <ul>

      <li>Brutus - Grizzly</li>

      <li>Iceman - Polar</li>

      <li>Kenai - Grizzly</li>

      <li>Paddington - Brown</li>

      <li>Roscoe - Panda</li>

      <li>Rosie - Black</li>

      <li>Scarface - Grizzly</li>

      <li>Smokey - Black</li>

      <li>Snow - Polar</li>

      <li>Teddy - Brown</li>

    </ul>
    """
  end

  test "Test GET /bears/new" do
    request = """
    GET /bears/new HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body ==
    """
    <form action="/bears" method="POST">
      <p>
        Name:<br/>
        <input type="text" name="name">
      </p>
      <p>
        Type:<br/>
        <input type="text" name="type">
      </p>
      <p>
        <input type="submit" value="Create Bear">
      </p>
    </form>
    """
  end

  test "Test GET /bears/{id} where {id} is a number." do
    request = """
    GET /bears/9 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == """
    <h1>Show Bear</h1>
    <p>
        Is Iceman 9 hibernating? <strong>true</strong>
    </p>
    """
  end

  test "Test GET /about" do
    request = """
    GET /about HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == """
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>
    """
  end

  test "Test POST /bears" do
    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Lenght: 21

    name=Baloo&type=Brown
    """
    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.resp_body == "New Bear named: #{conv.params["name"]}, of type: #{conv.params["type"]}"
  end

  test "Test get path that is not found. It returns 404" do
    request = """
    GET /pokemon HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.status_code == 404
    assert response.resp_body == "#{conv.path} not found"
  end

  test "Test JSON response for /api/bears" do
    request = """
    GET /api/bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    conv = Handler.parse(request)
    response = Router.route(conv)

    assert response.status_code == 200
    assert response.resp_body == "[{\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Iceman\",\"id\":9,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Paddington\",\"id\":3,\"hibernating\":false},{\"type\":\"Panda\",\"name\":\"Roscoe\",\"id\":8,\"hibernating\":false},{\"type\":\"Black\",\"name\":\"Rosie\",\"id\":7,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Smokey\",\"id\":2,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Snow\",\"id\":5,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Teddy\",\"id\":1,\"hibernating\":true}]"
    assert response == %Conv{method: "GET",
                            headers: %{"Accept" => "*/*", "Host" => "example.com", "User-Agent" => "ExampleBrowser/1.0"},
                            path: "/api/bears",
                            status_code: 200,
                            params: %{},
                            content_type: "application/json",
                            resp_body: "[{\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Iceman\",\"id\":9,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Paddington\",\"id\":3,\"hibernating\":false},{\"type\":\"Panda\",\"name\":\"Roscoe\",\"id\":8,\"hibernating\":false},{\"type\":\"Black\",\"name\":\"Rosie\",\"id\":7,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Smokey\",\"id\":2,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Snow\",\"id\":5,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Teddy\",\"id\":1,\"hibernating\":true}]"
                            }
  end

end
