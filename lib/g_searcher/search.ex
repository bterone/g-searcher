defmodule GSearcher.Search do
  import Ecto.Query, warn: false

  alias GSearcher.Repo
  alias GSearcher.Search.{ReportSearchResult, SearchResult}

  def get_search_result!(id), do: Repo.get!(SearchResult, id)

  def create_search_result(attrs) do
    %SearchResult{}
    |> SearchResult.create_keyword_changeset(attrs)
    |> Repo.insert()
  end

  def associate_search_result_to_report(attrs) do
    %ReportSearchResult{}
    |> ReportSearchResult.changeset(attrs)
    |> Repo.insert()
  end
end
