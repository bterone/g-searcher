defmodule GSearcherWeb.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.Search
  alias GSearcher.Search.SearchResult

  def show(conn, %{"id" => id}) do
    search_result = Search.get_search_result!(id)
    render(conn, "show.html", search_result: search_result)
  end
end
