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

end
