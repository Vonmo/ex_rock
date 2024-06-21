db_path = Path.join(System.tmp_dir!(), "test_db_#{UUID.uuid4()}")
ExRock.destroy(db_path)
{:ok, db} = ExRock.open(db_path)
d = UUID.uuid4()
:ok = ExRock.put(db, d, d)

Benchee.run(
  %{
    "read" => fn ->
      {:ok, ^d} = ExRock.get(db, d)
    end,
  },
  parallel: 2,
  warmup: 5,
  time: 10,
  memory_time: 5
)
