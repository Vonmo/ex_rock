defmodule ExRockTest do
  use ExRock.Case
  doctest ExRock

  describe "common" do
    test "check lxcode/0 returns" do
      assert ExRock.lxcode() == {:ok, :vsn1}
    end
  end

  describe "app" do
    test "correct loading" do
      app = :ex_rock
      Application.stop(app)
      Application.unload(app)
      assert :ok == Application.load(app)
    end
  end
end
