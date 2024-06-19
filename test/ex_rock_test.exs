defmodule ExRockTest do
  use ExUnit.Case
  doctest ExRock

  describe "common" do
    test "check lxcode/0 returns" do
      assert ExRock.lxcode() == {:ok, :vsn1}
    end
  end

  describe "atomic" do
  end

  describe "iterator" do
  end

  describe "cf" do
  end

  describe "snapshot" do
  end

  describe "checkpoint" do
  end

  describe "backup" do
  end

  describe "perf" do
  end
end
