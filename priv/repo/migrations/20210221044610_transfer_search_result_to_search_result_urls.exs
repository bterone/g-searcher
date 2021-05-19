defmodule GSearcher.Repo.Migrations.TransferSearchResultToSearchResultURLs do
  use Ecto.Migration

  alias Ecto.Multi
  alias GSearcher.Repo
  alias GSearcher.SearchResults.{SearchResult, SearchResultParser, SearchResultURL}

  def up do
    transfer_to_search_result_urls()
  end

  def down do
  end

  defp transfer_to_search_result_urls do
    search_results = Repo.all(SearchResult)

    Enum.each(search_results, fn %{html_cache: html_cache} = search_result ->
      {:ok, search_result_details} = SearchResultParser.parse(html_cache)

      create_search_result_urls(search_result, search_result_details)
    end)
  end

  defp create_search_result_urls(search_result, %{
         top_advertiser_urls: top_ads,
         regular_advertiser_urls: regular_ads,
         search_result_urls: search_result_urls
       }) do
    Multi.new()
    |> Multi.run(:create_top_ads, fn _, _ ->
      create_search_result_url(search_result, top_ads)
    end)
    |> Multi.run(:create_regular_ads, fn _, _ ->
      create_search_result_url(search_result, regular_ads)
    end)
    |> Multi.run(:create_search_result_urls, fn _, _ ->
      create_search_result_url(search_result, search_result_urls)
    end)
    |> Repo.transaction()
  end

  defp create_search_result_url(%SearchResult{id: id}, result_urls) when is_list(result_urls) do
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
end
