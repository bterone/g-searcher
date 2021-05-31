defmodule GSearcherWeb.Helpers.ParamsValidator do
  alias Ecto.Changeset

  def validate(query, as: params_module) do
    query
    |> params_module.changeset()
    |> handle_changeset()
  end

  defp handle_changeset(%Changeset{valid?: true} = changeset),
    do: {:ok, extract_changes(changeset)}

  defp handle_changeset(changeset), do: {:error, :invalid_params, put_action(changeset)}

  defp extract_changes(%Changeset{} = changeset) do
    Enum.reduce(changeset.changes, %{}, fn {key, value}, params ->
      Map.put(params, key, extract_changes(value))
    end)
  end

  defp extract_changes([%Changeset{} | _] = changesets) do
    Enum.map(changesets, &extract_changes/1)
  end

  defp extract_changes(value) do
    value
  end

  defp put_action(%Changeset{} = changeset) do
    changeset |> Map.put(:action, :validate)
  end
end
