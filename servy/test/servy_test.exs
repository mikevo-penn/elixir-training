defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "Hello world" do
    assert Servy.hello("Vo Money") == "Hello, Vo Money"
  end
end
