defmodule Servy.Api.BearController do

  alias Servy.BearFarm
  alias Servy.Bear

  def index(conv) do
    bears = BearFarm.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

      content = Poison.encode!(bears)

    %{ conv | status_code: 200, content_type: "application/json", resp_body: content }
  end

end
