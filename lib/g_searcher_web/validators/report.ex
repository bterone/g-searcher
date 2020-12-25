defmodule GSearcherWeb.Validators.Report do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :csv, :any, virtual: true
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [
      :title,
      :csv
    ])
    |> validate_required([:title, :csv])
    |> validate_is_csv()
  end

  defp validate_is_csv(%Ecto.Changeset{changes: %{csv: %{content_type: "text/csv"}}} = changeset),
    do: changeset

  defp validate_is_csv(changeset),
    do: add_error(changeset, :csv, "is not a CSV")
end
