defmodule OptimusTest do
  use ExUnit.Case
  doctest Optimus

  test "greets the world" do
    assert Optimus.hello() == :world
  end
end
