defmodule ExRock.Performance.Test do
  use ExRock.Case

  describe "performance checks" do
    test "basic check", context do
      {:ok, db} = ExRock.open(context.db_path)

      w =
        :perftest.comprehensive(1000, fn ->
          i = UUID.uuid4()
          :ok = ExRock.put(db, i, i)
        end)

      assert w |> Enum.all?(&(&1 >= 5000))

      :ok = ExRock.put(db, "k0", "v0")

      r =
        :perftest.comprehensive(1000, fn ->
          {:ok, "v0"} = ExRock.get(db, "k0")
        end)

      assert r |> Enum.all?(&(&1 >= 5000))
    end
  end
end
