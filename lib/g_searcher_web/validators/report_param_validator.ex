defmodule GSearcher.Validators.ReportParamValidator do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :csv, :any, virtual: true
  end

  def validate(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [
      :title,
      :csv
    ])
    |> validate_required([:title, :csv])
    |> validate_is_csv()
    |> add_validate_action()
    |> handle_changeset()
  end

  defp validate_is_csv(%Ecto.Changeset{changes: %{csv: %{content_type: "text/csv"}}} = changeset),
    do: changeset

  defp validate_is_csv(changeset),
    do: add_error(changeset, :csv, "is not a CSV")

  defp handle_changeset(%Ecto.Changeset{changes: changes, valid?: true}),
    do: {:ok, changes}

  defp handle_changeset(changeset) do
    {:error, :invalid_params, changeset}
  end

  defp add_validate_action(changeset),
    do: %{changeset | action: :validate}
end
