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

  using do
    quote do
      import ExRock.Case

      @app :ex_rock
    end
  end

  setup_all context do
    context
  end

  setup _tags do
    db_path = Path.join(System.tmp_dir!(), "test_db_#{UUID.uuid4()}")
    ExRock.destroy(db_path)

    on_exit(fn ->
      ExRock.destroy(db_path)
    end)

    %{db_path: db_path}
  end
end
