defmodule GSearcher.SearchResults do
  import Ecto.Query, warn: false

  alias GSearcher.Repo
  alias GSearcher.SearchResults.{ReportSearchResult, SearchResult}

  def create_search_result(attrs) do
    %SearchResult{}
    |> SearchResult.create_keyword_changeset(attrs)
    |> Repo.insert()
  end

  def associate_search_result_to_report(report_id, search_result_id) do
    %ReportSearchResult{}
    |> ReportSearchResult.changeset(%{report_id: report_id, search_result_id: search_result_id})
    |> Repo.insert()
  end

  def update_search_result(search_result_id, params) do
    SearchResult
    |> Repo.get(search_result_id)
    |> SearchResult.update_search_result_changeset(params)
    |> Repo.update()
  end
end
