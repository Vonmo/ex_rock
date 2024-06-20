defmodule ExRock.Atomic.Test do
  use ExRock.Case

  describe "atomic" do
    test "put_get", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "key", "value")
      {:ok, "value"} = ExRock.get(db, "key")
      :ok = ExRock.put(db, "key", "value1")
      {:ok, "value1"} = ExRock.get(db, "key")
      :ok = ExRock.put(db, "key", "value2")
      {:ok, "value2"} = ExRock.get(db, "key")
      :undefined = ExRock.get(db, "unknown")
      {:ok, "default"} = ExRock.get(db, "unknown", "default")
    end

    test "put_get_bin", context do
      key = :erlang.term_to_binary({:test, :key})
      val = :erlang.term_to_binary({:test, :val})
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, key, val)
      {:ok, ^val} = ExRock.get(db, key)
    end

    test "delete", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "key", "value")
      {:ok, "value"} = ExRock.get(db, "key")
      :ok = ExRock.delete(db, "key")
      :undefined = ExRock.get(db, "key")
    end

    test "write_batch", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, 4} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:delete, "k0"},
          {:put, "k3", "v3"}
        ])

      :undefined = ExRock.get(db, "k0")
      {:ok, "v1"} = ExRock.get(db, "k1")
      {:ok, "v2"} = ExRock.get(db, "k2")
      {:ok, "v3"} = ExRock.get(db, "k3")
    end

    test "delete_range", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      :ok = ExRock.delete_range(db, "k2", "k4")
      {:ok, "v1"} = ExRock.get(db, "k1")
      :undefined = ExRock.get(db, "k2")
      :undefined = ExRock.get(db, "k3")
      {:ok, "v4"} = ExRock.get(db, "k4")
      {:ok, "v5"} = ExRock.get(db, "k5")
    end

    test "multi_get", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 3} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"}
        ])

      {:ok,
       [
         :undefined,
         {:ok, "v1"},
         {:ok, "v2"},
         {:ok, "v3"},
         :undefined,
         :undefined
       ]} =
        ExRock.multi_get(db, [
          "k0",
          "k1",
          "k2",
          "k3",
          "k4",
          "k5"
        ])
    end

    test "key_may_exist", context do
      {:ok, db} = ExRock.open(context.db_path)
      {:ok, false} = ExRock.key_may_exist(db, "k1")
      :ok = ExRock.put(db, "k1", "v1")
      {:ok, true} = ExRock.key_may_exist(db, "k1")
    end
  end
end
