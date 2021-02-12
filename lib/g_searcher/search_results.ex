defmodule GSearcher.SearchResults do
  import Ecto.Query, warn: false

  alias GSearcher.Repo
  alias GSearcher.SearchResults.{ReportSearchResult, SearchResult}

  def create_search_result(attrs) do
    %SearchResult{}
    |> SearchResult.create_keyword_changeset(attrs)
    |> Repo.insert()
  end

  def get_search_result(search_result_id) do
    SearchResult
    |> Repo.get(search_result_id)
    |> case do
      nil -> {:error, :not_found}
      search_result -> {:ok, search_result}
    end
  end

  def get_user_search_result(search_result_id, user_id) do
    SearchResult
    |> join(:full, [sr], rsr in assoc(sr, :report_search_result))
    |> join(:full, [rsr], r in assoc(rsr, :reports))
    |> where([sr, _, r], sr.id == ^search_result_id and r.user_id == ^user_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      search_result -> {:ok, search_result}
    end
  end

  def get_search_results_from_report(report_id) do
    SearchResult
    |> join(:full, [sr], rsr in ReportSearchResult, on: sr.id == rsr.search_result_id)
    |> where([sr, rsr], rsr.report_id == ^report_id)
    |> Repo.all()
    |> case do
      [] -> {:error, :not_found}
      search_results -> {:ok, search_results}
    end
  end

  def update_search_result(search_result, params) do
    search_result
    |> SearchResult.update_search_result_changeset(params)
    |> Repo.update()
  end

  def associate_search_result_to_report(report_id, search_result_id) do
    %ReportSearchResult{}
    |> ReportSearchResult.changeset(%{report_id: report_id, search_result_id: search_result_id})
    |> Repo.insert()
  end
end
