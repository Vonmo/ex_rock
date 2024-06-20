defmodule ExRock.Test.Helpers do
  @moduledoc false

  def clean_dirs(state, %{clean_dirs: [_ | _] = dirs}) do
    dirs
    |> Enum.each(&File.rm_rf!(&1))

    state
  end

  def clean_dirs(state, _), do: state

  # ----------------------------------------------------------------------------

  def wait(_, 0, _), do: :timeout

  def wait(single_operation_timeout, repeat_count, func) do
    result =
      try do
        func.()
      rescue
        e -> e
      catch
        e -> e
      end

    case result do
      :ok ->
        :ok

      true ->
        :ok

      {:error, reason} ->
        {:error, reason}

      {:return, some} ->
        some

      _ ->
        Process.sleep(single_operation_timeout)
        wait(single_operation_timeout, repeat_count - 1, func)
    end
  end
end
