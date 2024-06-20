defmodule ExRock.Iterator.Test do
  use ExRock.Case, async: true

  describe "iterator" do
    test "create_iterator", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, start_ref} = ExRock.iterator(db, {:start})
      assert is_reference(start_ref)

      {:ok, end_ref} = ExRock.iterator(db, {:end})
      assert is_reference(end_ref)

      {:ok, from_ref1} = ExRock.iterator(db, {:from, "k0", :forward})
      assert is_reference(from_ref1)

      {:ok, from_ref2} = ExRock.iterator(db, {:from, "k0", :reverse})
      assert is_reference(from_ref2)

      {:ok, from_ref3} = ExRock.iterator(db, {:from, "k1", :forward})
      assert is_reference(from_ref3)

      {:ok, from_ref4} = ExRock.iterator(db, {:from, "k1", :reverse})
      assert is_reference(from_ref4)
      {:ok, "k0", _} = ExRock.next(from_ref4)
    end

    test "next_start", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")
      :ok = ExRock.put(db, "k1", "v1")
      :ok = ExRock.put(db, "k2", "v2")

      {:ok, iter} = ExRock.iterator(db, {:start})
      {:ok, "k0", "v0"} = ExRock.next(iter)
      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "next_end", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")
      :ok = ExRock.put(db, "k1", "v1")
      :ok = ExRock.put(db, "k2", "v2")

      {:ok, iter} = ExRock.iterator(db, {:end})
      {:ok, "k2", "v2"} = ExRock.next(iter)
      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k0", "v0"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "next_from_forward", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")
      :ok = ExRock.put(db, "k1", "v1")
      :ok = ExRock.put(db, "k2", "v2")

      {:ok, iter} = ExRock.iterator(db, {:from, "k1", :forward})
      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "next_from_reverse", context do
      {:ok, db} = ExRock.open(context.db_path)
      :ok = ExRock.put(db, "k0", "v0")
      :ok = ExRock.put(db, "k1", "v1")
      :ok = ExRock.put(db, "k2", "v2")

      {:ok, iter} = ExRock.iterator(db, {:from, "k1", :reverse})
      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k0", "v0"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "prefix_iterator", context do
      {:ok, db} =
        ExRock.open(context.db_path, %{
          set_prefix_extractor_prefix_length: 3,
          create_if_missing: true
        })

      :ok = ExRock.put(db, "aaa1", "va1")
      :ok = ExRock.put(db, "bbb1", "vb1")
      :ok = ExRock.put(db, "aaa2", "va2")
      {:ok, iter} = ExRock.prefix_iterator(db, "aaa")
      true = is_reference(iter)
      {:ok, "aaa1", "va1"} = ExRock.next(iter)
      {:ok, "aaa2", "va2"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)

      {:ok, iter2} = ExRock.prefix_iterator(db, "bbb")
      true = is_reference(iter2)
      {:ok, "bbb1", "vb1"} = ExRock.next(iter2)
      :end_of_iterator = ExRock.next(iter2)
    end

    test "iterator_range_start", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:start}, "k2", "k4")
      true = is_reference(iter)

      {:ok, "k2", "v2"} = ExRock.next(iter)
      {:ok, "k3", "v3"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_end", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:end}, "k2", "k4")
      true = is_reference(iter)

      {:ok, "k3", "v3"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_from", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:from, "k3", :forward}, "k2", "k5")
      true = is_reference(iter)

      {:ok, "k3", "v3"} = ExRock.next(iter)
      {:ok, "k4", "v4"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_from_reverse", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:from, "k3", :reverse}, "k2", "k5")
      true = is_reference(iter)

      {:ok, "k3", "v3"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_undefined_left_border", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:start}, :undefined, "k4")
      true = is_reference(iter)

      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      {:ok, "k3", "v3"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_undefined_right_border", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:start}, "k2", :undefined)
      true = is_reference(iter)

      {:ok, "k2", "v2"} = ExRock.next(iter)
      {:ok, "k3", "v3"} = ExRock.next(iter)
      {:ok, "k4", "v4"} = ExRock.next(iter)
      {:ok, "k5", "v5"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end

    test "iterator_range_undefined_both_borders", context do
      {:ok, db} = ExRock.open(context.db_path)

      {:ok, 5} =
        ExRock.write_batch(db, [
          {:put, "k1", "v1"},
          {:put, "k2", "v2"},
          {:put, "k3", "v3"},
          {:put, "k4", "v4"},
          {:put, "k5", "v5"}
        ])

      {:ok, iter} = ExRock.iterator_range(db, {:start}, :undefined, :undefined)
      true = is_reference(iter)

      {:ok, "k1", "v1"} = ExRock.next(iter)
      {:ok, "k2", "v2"} = ExRock.next(iter)
      {:ok, "k3", "v3"} = ExRock.next(iter)
      {:ok, "k4", "v4"} = ExRock.next(iter)
      {:ok, "k5", "v5"} = ExRock.next(iter)
      :end_of_iterator = ExRock.next(iter)
    end
  end
end
