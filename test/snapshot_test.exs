defmodule ExRock.Snapshot.Test do
  use ExRock.Case, async: true

  describe "snapshot" do
    test "create_snapshot", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 2} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"}
        ])

      {:ok, {:snap, _, snap_ref} = snap} = ExRock.snapshot(db)
      assert is_reference(snap_ref)
      :ok = ExRock.put(db, "k3", "v3")

      {:ok, "v1"} = ExRock.snapshot_get(snap, "k1")
      {:ok, "v2"} = ExRock.snapshot_get(snap, "k2")
      :undefined = ExRock.snapshot_get(snap, "k3")
      {:ok, "v3"} = ExRock.get(db, "k3")
    end

    test "snapshot_multi_get", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 3} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"}
        ])

      {:ok, snap} = ExRock.snapshot(db)
      :ok = ExRock.put(db, "k4", "v4")

      {:ok,
       [
         :undefined,
         {:ok, "v1"},
         {:ok, "v2"},
         {:ok, "v3"},
         :undefined,
         :undefined
       ]} =
        ExRock.snapshot_multi_get(snap, [
          "k0",
          "k1",
          "k2",
          "k3",
          "k4",
          "k5"
        ])
    end

    test "snapshot_get_cf", context do
      test = self()

      spawn(fn ->
        {:ok, db} = ExRock.open(context.db_path)
        :ok = ExRock.create_cf(db, "testcf")
        send(test, :ok)
      end)

      assert_receive(:ok, 1000)

      {:ok, db} =
        ExRock.open_cf(
          context.db_path,
          ["testcf"]
        )

      :ok = ExRock.put_cf(db, "testcf", "key1", "value1")
      {:ok, snap} = ExRock.snapshot(db)
      :ok = ExRock.put_cf(db, "testcf", "key2", "value2")

      {:ok, "value1"} = ExRock.get_cf(db, "testcf", "key1")
      {:ok, "value2"} = ExRock.get_cf(db, "testcf", "key2")

      {:ok, "value1"} = ExRock.snapshot_get_cf(snap, "testcf", "key1")
      :undefined = ExRock.snapshot_get_cf(snap, "testcf", "key2")
    end

    test "snapshot_multi_get_cf", context do
      {:ok, db} = ExRock.open(context.db_path)
      cf1 = "test_cf1"
      :ok = ExRock.create_cf(db, cf1)
      cf2 = "test_cf2"
      :ok = ExRock.create_cf(db, cf2)
      cf3 = "test_cf3"
      :ok = ExRock.create_cf(db, cf3)

      {:ok, 3} =
        ExRock.write_batch(db, [
          {:put_cf, cf1, "k1", "v1"},
          {:put_cf, cf2, "k2", "v2"},
          {:put_cf, cf3, "k3", "v3"}
        ])

      {:ok, snap} = ExRock.snapshot(db)

      {:ok, 3} =
        ExRock.write_batch(db, [
          {:put_cf, cf1, "k11", "v11"},
          {:put_cf, cf2, "k22", "v23"},
          {:put_cf, cf3, "k33", "v33"}
        ])

      {:ok,
       [
         {:ok, "v1"},
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         {:ok, "v2"},
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         :undefined,
         {:ok, "v3"},
         :undefined,
         :undefined,
         :undefined
       ]} =
        ExRock.snapshot_multi_get_cf(snap, [
          {cf1, "k1"},
          {cf1, "k2"},
          {cf1, "k3"},
          {cf1, "k11"},
          {cf1, "k22"},
          {cf1, "k33"},
          {cf2, "k1"},
          {cf2, "k2"},
          {cf2, "k3"},
          {cf2, "k11"},
          {cf2, "k22"},
          {cf2, "k33"},
          {cf3, "k1"},
          {cf3, "k2"},
          {cf3, "k3"},
          {cf3, "k11"},
          {cf3, "k22"},
          {cf3, "k33"}
        ])
    end

    test "snapshot_iterator", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")
      {:ok, snap} = ExRock.snapshot(db)

      {:ok, start_ref} = ExRock.snapshot_iterator(snap, {:start})
      assert is_reference(start_ref)

      {:ok, end_ref} = ExRock.snapshot_iterator(snap, {:end})
      assert is_reference(end_ref)

      {:ok, from_ref1} = ExRock.snapshot_iterator(snap, {:from, "k0", :forward})
      assert is_reference(from_ref1)

      {:ok, from_ref2} = ExRock.snapshot_iterator(snap, {:from, "k0", :reverse})
      assert is_reference(from_ref2)

      {:ok, from_ref3} = ExRock.snapshot_iterator(snap, {:from, "k1", :forward})
      assert is_reference(from_ref3)

      {:ok, from_ref4} = ExRock.snapshot_iterator(snap, {:from, "k1", :reverse})
      assert is_reference(from_ref4)

      {:ok, "k0", _} = ExRock.next(from_ref4)
    end

    test "snapshot_iterator_cf", context do
      {:ok, db} = ExRock.open(context.db_path)
      cf = "test_cf"
      :ok = ExRock.create_cf(db, cf)
      :ok = ExRock.put_cf(db, cf, "k0", "v0")

      {:ok, snap} = ExRock.snapshot(db)

      {:ok, start_ref} = ExRock.snapshot_iterator_cf(snap, cf, {:start})
      assert is_reference(start_ref)

      {:ok, end_ref} = ExRock.snapshot_iterator_cf(snap, cf, {:end})
      assert is_reference(end_ref)

      {:ok, from_ref1} = ExRock.snapshot_iterator_cf(snap, cf, {:from, "k0", :forward})
      assert is_reference(from_ref1)

      {:ok, from_ref2} = ExRock.snapshot_iterator_cf(snap, cf, {:from, "k0", :reverse})
      assert is_reference(from_ref2)

      {:ok, from_ref3} = ExRock.snapshot_iterator_cf(snap, cf, {:from, "k1", :forward})
      assert is_reference(from_ref3)

      {:ok, from_ref4} = ExRock.snapshot_iterator_cf(snap, cf, {:from, "k1", :reverse})
      assert is_reference(from_ref4)

      {:ok, "k0", _} = ExRock.next(from_ref4)
    end
  end
end
