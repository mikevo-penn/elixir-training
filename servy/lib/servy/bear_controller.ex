defmodule Servy.BearController do

  alias Servy.BearFarm

  def index(conv) do
    items = Enum.map(BearFarm.list_bears, fn(x) -> "<li>#{x.name} - #{x.type}</li>" end)

    %{ conv | status_code: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{ "id" => id} ) do
    %{ conv | status_code: 200, resp_body: "Bear: #{id}" }
  end

  def create(conv, params) do
    %{ conv | status_code: 201, resp_body: "New Bear named: #{conv.params["name"]}, of type: #{conv.params["type"]}"}
  end
end
