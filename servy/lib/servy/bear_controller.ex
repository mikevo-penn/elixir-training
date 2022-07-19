defmodule Servy.BearController do
  @templates_path Path.expand("../../templates", __DIR__)

  alias Servy.BearFarm
  alias Servy.Bear

  def index(conv) do
    bears = BearFarm.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

      content = @templates_path
      |> Path.join("index.eex")
      |> EEx.eval_file(bears: bears)

    %{ conv | status_code: 200, resp_body: content }
  end

  def show(conv, %{ "id" => id} ) do
    bear = BearFarm.get_bear(id)

    content = @templates_path
      |> Path.join("show.eex")
      |> EEx.eval_file([bear: bear, id: id])

    %{ conv | status_code: 200, resp_body: content }
  end

  def create(conv) do
    %{ conv | status_code: 201, resp_body: "New Bear named: #{conv.params["name"]}, of type: #{conv.params["type"]}"}
  end
end
