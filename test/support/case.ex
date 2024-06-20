defmodule ExRock.Case do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  import ExRock.Test.Helpers

  using do
    quote do
      import ExRock.Case
    end
  end

  setup_all context do
    context
  end

  setup tags do
    db_path = Path.join(System.tmp_dir!(), "test_db_#{UUID.uuid4()}")
    File.mkdir_p!(db_path)

    on_exit(fn ->
      File.rm_rf!(db_path)
    end)

    %{db_path: db_path}
    |> clean_dirs(tags)
  end
end
