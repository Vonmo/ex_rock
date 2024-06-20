defmodule ExRock.Init.Test do
  use ExRock.Case

  describe "create or open database" do
    test "open" do
    end

    test "open_default" do
    end

    test "open_multi_ptr" do
    end

    test "open_for_read_only" do
    end
  end

  describe "destroy or repair database" do
    test "destroy" do
    end

    test "repair" do
    end
  end

  describe "db tools" do
    test "get_db_path", context do
      path = context.db_path
      {:ok, db} = ExRock.open(path)
      {:ok, ^path} = ExRock.get_db_path(db)
    end

    test "latest_sequence_number", context do
      {:ok, db} = ExRock.open(context.db_path)
      {:ok, 0} = ExRock.latest_sequence_number(db)
      :ok = ExRock.put(db, "k1", "v1")
      {:ok, 1} = ExRock.latest_sequence_number(db)
      :ok = ExRock.put(db, "k2", "v2")
      {:ok, 2} = ExRock.latest_sequence_number(db)
    end
  end
end
