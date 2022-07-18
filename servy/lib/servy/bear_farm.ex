defmodule Servy.BearFarm do
  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black"},
      %Bear{id: 3, name: "Paddington", type: "Brown"},
      %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar"},
      %Bear{id: 6, name: "Brutus", type: "Grizzly"},
      %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Panda"},
      %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Grizzly"}
    ]
  end

  @doc """
  Gets a bear from the list of 10.

  ## Example 1 - Get a bear based an id #1
    iex> alias Servy.Bear
    iex> alias Servy.BearFarm
    iex> id = 1
    iex> bear = BearFarm.get_bear(id)
    %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true}

  ## Example 2 - Get a bear based on id as a String "2"
    iex> alias Servy.Bear
    iex> alias Servy.BearFarm
    iex> id = "2"
    iex> bear = BearFarm.get_bear(id)
    %Bear{id: 2, name: "Smokey", type: "Black"}

  ## Example 3 - Get a bear that doesn't exist."
    iex> alias Servy.Bear
    iex> alias Servy.BearFarm
    iex> id = 69
    iex> bear = BearFarm.get_bear(id)
    nil
  """
  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(x) -> x.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end

end
