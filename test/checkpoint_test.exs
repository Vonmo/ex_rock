defmodule ExRock.Checkpoint.Test do
  use ExRock.Case, async: true

  describe "checkpoint" do
    test "create_checkpoint", context do
      path = context.db_path
      cp_path = path <> "_cp"
      ExRock.destroy(path)
      ExRock.destroy(cp_path)

      {:ok, db} = ExRock.open(path)
      :ok = ExRock.put(db, "k0", "v0")
      :ok = ExRock.create_checkpoint(db, cp_path)

      {:ok, backup_db} = ExRock.open(cp_path)
      {:ok, "v0"} = ExRock.get(backup_db, "k0")
    end
  end
end
