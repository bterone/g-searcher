defmodule GSearcherWeb.Validators.ParamValidator do
  import Ecto.Changeset

  def validate(params, for: params_module) do
    params
    |> params_module.changeset()
    |> add_validate_action()
    |> handle_changeset()
  end

  defp add_validate_action(changeset), do: apply_action(changeset, :validate)

  defp handle_changeset({:ok, data}), do: {:ok, data}
  defp handle_changeset({:error, changeset}), do: {:error, :invalid_params, changeset}
end
