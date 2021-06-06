defmodule GSearcher.SearchResults do
  require Logger

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

  def list_search_results_by_user_id(user_id, filter_params \\ %{}) do
    SearchResult
    |> filter_by_search_term(filter_params)
    |> filter_by_top_ads(filter_params)
    |> filter_by_regular_ads(filter_params)
    |> join(:full, [sr], rsr in assoc(sr, :report_search_result))
    |> join(:full, [rsr], r in assoc(rsr, :reports))
    |> where([_, _, r], r.user_id == ^user_id)
    |> filter_by_report_title(filter_params)
    |> join(:left, [sr], sr_url in assoc(sr, :search_result_urls))
    |> filter_by_url(filter_params)
    |> Repo.all()
  end

  def update_search_result(search_result, params) do
    search_result
    |> SearchResult.update_search_result_changeset(params)
    |> Repo.update()
  end

  def create_search_result_url(%SearchResult{id: id}, result_urls) when is_list(result_urls) do
    result_urls
    |> Enum.map(fn result_url ->
      {_, result} = create_search_result_url(Map.merge(result_url, %{search_result_id: id}))

      result
    end)
    |> Enum.take_while(&is_changeset?/1)
    |> case do
      [] ->
        {:ok, :saved_all_urls}

      changesets ->
        Logger.error("partially_saved_urls: Some URLs could not be saved: #{inspect(changesets)}")
        {:ok, :partially_saved_urls}
    end
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

  defp filter_by_search_term(query, %{search_term: search_term}),
    do: where(query, [sr], like(sr.search_term, ^"%#{escape_percentage_sign(search_term)}%"))

  defp filter_by_search_term(query, _), do: query

  defp filter_by_top_ads(query, %{top_ads: <<operator::binary-size(1), ad_count::binary>>}) do
    {value, _} = Integer.parse(ad_count)

    where_count(query, :number_of_top_advertisers, operator, value)
  end

  defp filter_by_top_ads(query, _), do: query

  defp filter_by_regular_ads(query, %{regular_ads: <<operator::binary-size(1), ad_count::binary>>}) do
    {value, _} = Integer.parse(ad_count)

    where_count(query, :number_of_regular_advertisers, operator, value)
  end

  defp filter_by_regular_ads(query, _), do: query

  defp filter_by_report_title(query, %{title: report_title}),
    do: where(query, [_, _, r], like(r.title, ^"%#{escape_percentage_sign(report_title)}%"))

  defp filter_by_report_title(query, _), do: query

  defp filter_by_url(query, %{url: url}),
    do: where(query, [_, _, _, sr_url], like(sr_url.url, ^"%#{escape_percentage_sign(url)}%"))

  defp filter_by_url(query, _), do: query

  defp is_changeset?(%Ecto.Changeset{}), do: true
  defp is_changeset?(_), do: false

  defp where_count(query, field_name, "<", count),
    do: where(query, [v], fragment("? < ?", field(v, ^field_name), ^count))

  defp where_count(query, field_name, ">", count),
    do: where(query, [v], fragment("? > ?", field(v, ^field_name), ^count))

  defp where_count(query, field_name, "=", count),
    do: where(query, [v], fragment("? = ?", field(v, ^field_name), ^count))

  # TODO: Move to search_helper to sanitize user input in #41
  defp escape_percentage_sign(query), do: String.replace(query, "%", "\\%")
end
