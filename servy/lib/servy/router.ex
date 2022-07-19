defmodule Servy.Router do
  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.Api

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status_code: 200, resp_body: "Bears, Lions, Tigers, Dookie, Nöödle, and Mookie" }
  end

  def route(%Conv{method: "GET", path: "/wildthings/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/wildthings?id=" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/wildlife"} = conv) do
    conv = %{conv | path: "/wildthings"}
    route(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    file =
      @pages_path
      |> Path.join("form.html")

    case File.read(file) do
      {:ok, content} ->
        %{ conv | status_code: 200, resp_body: content }
      {:error, :onoent} ->
        %{ conv | status_code: 404, resp_body: "File not found" }
      {:error, reason} ->
        %{ conv | status_code: 200, resp_body: "File error: #{reason}" }
    end
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    file =
      @pages_path
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        %{ conv | status_code: 200, resp_body: content }
      {:error, :onoent} ->
        %{ conv | status_code: 404, resp_body: "File not found" }
      {:error, reason} ->
        %{ conv | status_code: 200, resp_body: "File error: #{reason}" }
    end
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv)
  end

  def route(%Conv{method: "GET", path: path} = conv) do
    %{ conv | status_code: 404, resp_body: "#{path} not found" }
  end
end
