defmodule GSearcherWeb.API.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.{SearchResults, SearchResultURLs}
  alias GSearcherWeb.ErrorHandler

  def index(conn, _params) do
    %{id: user_id} = conn.assigns.user

    search_results = SearchResults.list_search_results_by_user_id(user_id)

    conn
    |> put_status(:ok)
    |> render("index.json", %{search_results: search_results})
  end
end
