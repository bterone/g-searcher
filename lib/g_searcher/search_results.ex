defmodule GSearcher.SearchResults do
  import Ecto.Query, warn: false

  alias GSearcher.Repo
  alias GSearcher.SearchResults.{ReportSearchResult, SearchResult, SearchResultURL}

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

  def create_search_result_url(%SearchResult{id: id}, result_urls) when is_list(result_urls) do
    Enum.each(result_urls, fn result_url ->
      create_search_result_url(Map.merge(result_url, %{search_result_id: id}))
    end)

    {:ok, :saved_search_results}
  end

  def create_search_result_url(params) do
    %SearchResultURL{}
    |> SearchResultURL.create_changeset(params)
    |> Repo.insert()
  end

  def associate_search_result_to_report(report_id, search_result_id) do
    %ReportSearchResult{}
    |> ReportSearchResult.changeset(%{report_id: report_id, search_result_id: search_result_id})
    |> Repo.insert()
  end
end
