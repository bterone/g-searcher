defmodule GSearcherWeb.Validators.ParamsValidator do
  alias Ecto.Changeset

  def validate(params, as: params_module) do
    params
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

  defp extract_changes([%Changeset{} | _] = changesets),
    do: Enum.map(changesets, &extract_changes/1)

  defp extract_changes(value), do: value

  defp put_action(%Changeset{} = changeset) do
    changeset |> Map.put(:action, :validate)
  end
end
