defmodule GSearcher.SearchResults.ReportSearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSearcher.SearchResults.{Report, SearchResult}

  schema "reports_search_results" do
    belongs_to :report, Report
    belongs_to :search_result, SearchResult

    timestamps()
  end

  def changeset(report_search_result \\ %__MODULE__{}, attrs) do
    report_search_result
    |> cast(attrs, [:report_id, :search_result_id])
    |> validate_required([:report_id, :search_result_id])
    |> assoc_constraint(:report)
    |> assoc_constraint(:search_result)
  end
end
