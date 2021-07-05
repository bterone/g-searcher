defmodule GSearcherWeb.Validators.API.CreateReportParams do
  use Ecto.Schema

  import Ecto.Changeset

  @csv_mime_type "text/csv"

  embedded_schema do
    field :csv, :any, virtual: true
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:csv])
    |> validate_required(:csv)
    |> validate_csv_type()
  end

  defp validate_csv_type(
         %Ecto.Changeset{changes: %{csv: %{content_type: @csv_mime_type}}} = changeset
       ),
       do: changeset

  defp validate_csv_type(changeset),
    do: add_error(changeset, :csv, "is not a CSV")
end
