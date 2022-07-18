defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "greets the world" do
    assert Servy.hello("Vo Money") == "Hello, Vo Money"
  end
end
