defmodule GSearcher.Repo.Migrations.TransferSearchResultToSearchResultURLs do
  use Ecto.Migration

  import Ecto.Query

  alias Ecto.Changeset
  alias GSearcher.Repo
  alias GSearcher.SearchResults.{SearchResult, SearchResultURL}

  def up do
    transfer_to_search_result_urls()
  end

  def down do
  end

  defp transfer_to_search_result_urls do
    Enum.each(all_top_advertiser_urls(), fn %{id: id, url: search_result_url} ->
      %SearchResultURL{}
      |> Changeset.change(%{search_result_id: id, url: search_result_url, is_top_ad: true})
      |> Repo.insert()
    end)

    Enum.each(all_regular_advertiser_urls(), fn %{id: id, url: search_result_url} ->
      %SearchResultURL{}
      |> Changeset.change(%{search_result_id: id, url: search_result_url, is_regular_ad: true})
      |> Repo.insert()
    end)

    Enum.each(all_search_result_urls(), fn %{id: id, url: search_result_url} ->
      %SearchResultURL{}
      |> Changeset.change(%{search_result_id: id, url: search_result_url})
      |> Repo.insert()
    end)
  end

  defp all_top_advertiser_urls do
    search_results =
      SearchResult
      |> where([sr], not is_nil(sr.top_advertiser_urls))
      |> Repo.all()

    Enum.flat_map(search_results, fn search_result ->
      Enum.map(search_result.top_advertiser_urls, fn url ->
        %{id: search_result.id, url: url}
      end)
    end)
  end

  defp all_regular_advertiser_urls do
    search_results =
      SearchResult
      |> where([sr], not is_nil(sr.regular_advertiser_urls))
      |> Repo.all()

    Enum.flat_map(search_results, fn search_result ->
      Enum.map(search_result.regular_advertiser_urls, fn url ->
        %{id: search_result.id, url: url}
      end)
    end)
  end

  defp all_search_result_urls do
    search_results =
      SearchResult
      |> where([sr], not is_nil(sr.search_result_urls))
      |> Repo.all()

    Enum.flat_map(search_results, fn search_result ->
      Enum.map(search_result.search_result_urls, fn url ->
        %{id: search_result.id, url: url}
      end)
    end)
  end
end
