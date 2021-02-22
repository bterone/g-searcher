defmodule GSearcher.SearchResultURLs do
  import Ecto.Query, warn: false

  alias GSearcher.Repo
  alias GSearcher.SearchResults.SearchResultURL

  def get_by_search_result_id(search_result_id) do
    SearchResultURL
    |> where([sru], sru.search_result_id == ^search_result_id)
    |> Repo.all()
    |> case do
      [] -> {:ok, []}
      search_result_urls -> {:ok, search_result_urls}
    end
  end
end
