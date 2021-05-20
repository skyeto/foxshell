defmodule FoxshellTest do
  use ExUnit.Case
  doctest Foxshell

  test "greets the world" do
    assert Foxshell.hello() == :world
  end
end
