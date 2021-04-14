defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "greets the person" do
    assert Servy.hello("John") == "Howdy John"
  end
end
