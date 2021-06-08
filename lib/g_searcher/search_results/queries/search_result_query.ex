defmodule GSearcher.SearchResults.Queries.SearchResultQuery do
  import Ecto.Query, warn: false

  alias GSearcher.SearchResults.{Report, ReportSearchResult, SearchResult}

  def list_search_results_by_user_id(user_id, filter_params \\ %{}) do
    SearchResult
    |> filter_search_results(filter_params)
    |> join(:inner, [sr], rsr in ReportSearchResult, on: sr.id == rsr.search_result_id)
    |> join(:inner, [_, rsr], r in Report, on: r.id == rsr.report_id)
    |> where([_, _, r], r.user_id == ^user_id)
    |> filter_by_report_title(filter_params)
    |> join(:left, [sr], sr_url in assoc(sr, :search_result_urls))
    |> filter_by_url(filter_params)
    |> distinct(true)
    |> order_by(:id)
  end

  defp filter_search_results(query, filter_params) do
    query
    |> filter_by_search_term(filter_params)
    |> filter_by_top_ads(filter_params)
    |> filter_by_regular_ads(filter_params)
  end

  defp filter_by_search_term(query, %{search_term: search_term}),
    do: where(query, [sr], like(sr.search_term, ^"%#{search_term}%"))

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
    do: where(query, [_, _, r], like(r.title, ^"%#{report_title}%"))

  defp filter_by_report_title(query, _), do: query

  defp filter_by_url(query, %{url: url}),
    do: where(query, [_, _, _, sr_url], like(sr_url.url, ^"%#{url}%"))

  defp filter_by_url(query, _), do: query

  defp where_count(query, field_name, "<", count),
    do: where(query, [v], fragment("? < ?", field(v, ^field_name), ^count))

  defp where_count(query, field_name, ">", count),
    do: where(query, [v], fragment("? > ?", field(v, ^field_name), ^count))

  defp where_count(query, field_name, "=", count),
    do: where(query, [v], fragment("? = ?", field(v, ^field_name), ^count))
end
