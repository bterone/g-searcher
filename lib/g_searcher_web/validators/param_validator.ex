defmodule GSearcherWeb.Validators.ParamValidator do
  def validate(params, for: params_module) do
    params
    |> params_module.changeset()
    |> add_validate_action()
    |> handle_changeset()
  end

  defp handle_changeset(%Ecto.Changeset{changes: changes, valid?: true}),
    do: {:ok, changes}

  defp handle_changeset(changeset) do
    {:error, :invalid_params, changeset}
  end

  defp add_validate_action(changeset),
    do: %{changeset | action: :validate}
end
