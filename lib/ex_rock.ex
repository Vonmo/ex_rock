defmodule ExRock do
  @moduledoc """
  ExRock - wrapper for RocksDB.
  """

  alias :erlang, as: Erlang

  @version Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :ex_rock,
    crate: "rocker",
    base_url: "https://github.com/Vonmo/ex_rock/releases/download/v#{@version}",
    nif_versions: ["2.16", "2.17"],
    targets:
      Enum.uniq(["aarch64-unknown-linux-musl" | RustlerPrecompiled.Config.default_targets()]),
    force_build: String.downcase(System.get_env("FORCE_BUILD", "nope")) in ["1", "true", "yes"],
    version: @version

  def lxcode, do: Erlang.nif_error(:nif_not_loaded)
  def latest_sequence_number(_db_ref), do: Erlang.nif_error(:nif_not_loaded)
  def open(_path, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def open_for_read_only(_path, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def destroy(_path, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def repair(_path, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def get_db_path(_db_ref), do: Erlang.nif_error(:nif_not_loaded)
  def put(_db_ref, _key, _value), do: Erlang.nif_error(:nif_not_loaded)
  def get(_db_ref, _key), do: Erlang.nif_error(:nif_not_loaded)

  def get(db_ref, key, default) do
    case get(db_ref, key) do
      :undefined ->
        {:ok, default}

      some ->
        some
    end
  end

  def delete(_db_ref, _key), do: Erlang.nif_error(:nif_not_loaded)
  def write_batch(_db_ref, _ops), do: Erlang.nif_error(:nif_not_loaded)
  def iterator(_db_ref, _mode), do: Erlang.nif_error(:nif_not_loaded)

  def iterator_range(_db_ref, _mode, _from, _to, _read_options \\ %{}),
    do: Erlang.nif_error(:nif_not_loaded)

  def next(_iter_ref), do: Erlang.nif_error(:nif_not_loaded)
  def prefix_iterator(_db_ref, _prefix), do: Erlang.nif_error(:nif_not_loaded)
  def create_cf(_db_ref, _cf_name, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def open_cf(_path, _cf_names, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)

  def open_cf_for_read_only(_path, _cf_names, _options \\ %{}),
    do: Erlang.nif_error(:nif_not_loaded)

  def list_cf(_path, _options \\ %{}), do: Erlang.nif_error(:nif_not_loaded)
  def drop_cf(_db_ref, _cf_name), do: Erlang.nif_error(:nif_not_loaded)
  def put_cf(_db_ref, _cf_name, _key, _value), do: Erlang.nif_error(:nif_not_loaded)
  def get_cf(_db_ref, _cf_name, _key), do: Erlang.nif_error(:nif_not_loaded)

  def get_cf(db_ref, cf_name, key, default) do
    case get_cf(db_ref, cf_name, key) do
      :undefined ->
        {:ok, default}

      some ->
        some
    end
  end

  def delete_cf(_db_ref, _cf_name, _key), do: Erlang.nif_error(:nif_not_loaded)
  def iterator_cf(_db_ref, _cf_name, _mode), do: Erlang.nif_error(:nif_not_loaded)
  def prefix_iterator_cf(_db_ref, _cf_name, _prefix), do: Erlang.nif_error(:nif_not_loaded)
  def delete_range(_db_ref, _key_from, _key_to), do: Erlang.nif_error(:nif_not_loaded)

  def delete_range_cf(_db_ref, _cf_name, _key_from, _key_to),
    do: Erlang.nif_error(:nif_not_loaded)

  def multi_get(_db_ref, _keys), do: Erlang.nif_error(:nif_not_loaded)
  def multi_get_cf(_db_ref, _keys), do: Erlang.nif_error(:nif_not_loaded)
  def key_may_exist(_db_ref, _key), do: Erlang.nif_error(:nif_not_loaded)
  def key_may_exist_cf(_db_ref, _cf_name, _key), do: Erlang.nif_error(:nif_not_loaded)
  def snapshot(_db_ref), do: Erlang.nif_error(:nif_not_loaded)
  def snapshot_get(_snap_ref, _key), do: Erlang.nif_error(:nif_not_loaded)

  def snapshot_get(snap_ref, key, default) do
    case snapshot_get(snap_ref, key) do
      :undefined ->
        {:ok, default}

      some ->
        some
    end
  end

  def snapshot_get_cf(_snap_ref, _cf_name, _key), do: Erlang.nif_error(:nif_not_loaded)

  def snapshot_get_cf(snap_ref, cf_name, key, default) do
    case snapshot_get_cf(snap_ref, cf_name, key) do
      :undefined ->
        {:ok, default}

      some ->
        some
    end
  end

  def snapshot_multi_get(_snap_ref, _keys), do: Erlang.nif_error(:nif_not_loaded)
  def snapshot_multi_get_cf(_snap_ref, _keys), do: Erlang.nif_error(:nif_not_loaded)
  def snapshot_iterator(_snap_ref, _mode), do: Erlang.nif_error(:nif_not_loaded)
  def snapshot_iterator_cf(_snap_ref, _cf_name, _mode), do: Erlang.nif_error(:nif_not_loaded)
  def create_checkpoint(_db_ref, _path), do: Erlang.nif_error(:nif_not_loaded)
  def create_backup(_db_ref, _path), do: Erlang.nif_error(:nif_not_loaded)
  def get_backup_info(_backup_path), do: Erlang.nif_error(:nif_not_loaded)
  def purge_old_backups(_backup_path, _num_backups_to_keep), do: Erlang.nif_error(:nif_not_loaded)

  def restore_from_backup(_backup_path, _restore_path, _backup_id),
    do: Erlang.nif_error(:nif_not_loaded)

  def restore_from_backup(backup_path, restore_path),
    do: restore_from_backup(backup_path, restore_path, -1)
end
