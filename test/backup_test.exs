defmodule ExRock.Backup.Test do
  use ExRock.Case

  describe "backup" do
    test "create_backup", context do
      path = context.db_path
      backup_path = path <> "_backup"
      ExRock.destroy(path)
      ExRock.destroy(backup_path)

      {:ok, db} = ExRock.open(path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, [{:backup, 1, _, _, _}]} = ExRock.create_backup(db, backup_path)

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}]} = ExRock.get_backup_info(backup_path)
    end

    test "purge_old_backups", context do
      path = context.db_path
      backup_path = path <> "_backup"
      ExRock.destroy(path)
      ExRock.destroy(backup_path)

      {:ok, db} = ExRock.open(path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, [{:backup, 1, _, _, _}]} = ExRock.create_backup(db, backup_path)

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}, {:backup, 3, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      {:ok,
       [
         {:backup, 1, _, _, _},
         {:backup, 2, _, _, _},
         {:backup, 3, _, _, _},
         {:backup, 4, _, _, _}
       ]} = ExRock.create_backup(db, backup_path)

      {:ok, [{:backup, 3, _, _, _}, {:backup, 4, _, _, _}]} =
        ExRock.purge_old_backups(backup_path, 2)
    end

    test "restore_latest_backup", context do
      path = context.db_path
      backup_path = path <> "_backup"
      restore_path = path <> "_restore"
      ExRock.destroy(path)
      ExRock.destroy(backup_path)
      ExRock.destroy(restore_path)

      {:ok, db} = ExRock.open(path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, [{:backup, 1, _, _, _}]} = ExRock.create_backup(db, backup_path)
      :ok = ExRock.put(db, "k0", "v1")

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      :ok = ExRock.restore_from_backup(backup_path, restore_path)

      {:ok, restored} = ExRock.open(restore_path)
      {:ok, "v1"} = ExRock.get(restored, "k0")
    end

    test "restore_backup", context do
      path = context.db_path
      backup_path = path <> "_backup"
      restore_path = path <> "_restore"
      ExRock.destroy(path)
      ExRock.destroy(backup_path)
      ExRock.destroy(restore_path)

      {:ok, db} = ExRock.open(path)
      :ok = ExRock.put(db, "k0", "v0")

      {:ok, [{:backup, 1, _, _, _}]} = ExRock.create_backup(db, backup_path)
      :ok = ExRock.put(db, "k0", "v1")

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      :ok = ExRock.put(db, "k0", "v2")

      {:ok, [{:backup, 1, _, _, _}, {:backup, 2, _, _, _}, {:backup, 3, _, _, _}]} =
        ExRock.create_backup(db, backup_path)

      :ok = ExRock.restore_from_backup(backup_path, restore_path, 2)

      {:ok, restored} = ExRock.open(restore_path)
      {:ok, "v1"} = ExRock.get(restored, "k0")
    end
  end
end
