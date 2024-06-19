defmodule ExRockTest do
  use ExUnit.Case
  doctest ExRock

  test "greets the world" do
    assert ExRock.hello() == :world
  end
end
