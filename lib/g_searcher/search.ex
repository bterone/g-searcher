defmodule GSearcher.Search do
  import Ecto.Query, warn: false
  alias GSearcher.Repo

  alias GSearcher.Search.SearchResult

  def get_search_result!(id), do: Repo.get!(SearchResult, id)

  def create_search_result(attrs \\ %{}) do
    %SearchResult{}
    |> SearchResult.changeset(attrs)
    |> Repo.insert()
  end

  def update_search_result(%SearchResult{} = search_result, attrs) do
    search_result
    |> SearchResult.changeset(attrs)
    |> Repo.update()
  end

  def delete_search_result(%SearchResult{} = search_result) do
    Repo.delete(search_result)
  end

  def change_search_result(%SearchResult{} = search_result, attrs \\ %{}) do
    SearchResult.changeset(search_result, attrs)
  end
end
