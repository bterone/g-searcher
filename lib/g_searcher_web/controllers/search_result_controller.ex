defmodule GSearcherWeb.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.{SearchResults, SearchResultURLs}
  alias GSearcherWeb.ErrorHandler

  def index(conn, params) do
    %{id: user_id} = conn.assigns.current_user

    search_results = SearchResults.list_search_results_by_user_id(user_id, params["query"])

    render(conn, "index.html", search_results: Enum.with_index(search_results, 1))
  end

  def show(conn, %{"id" => search_result_id}) do
    %{id: user_id} = conn.assigns.current_user

    with {:ok, search_result} <- SearchResults.get_user_search_result(search_result_id, user_id),
         {:ok, search_result_urls} <- SearchResultURLs.get_by_search_result_id(search_result_id) do
      render(conn, "show.html",
        search_result: search_result,
        search_result_urls: search_result_urls
      )
    else
      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end

  # sobelow_skip ["XSS.Raw"]
  def result_snapshot(conn, %{"id" => search_result_id}) do
    %{id: user_id} = conn.assigns.current_user

    case SearchResults.get_user_search_result(search_result_id, user_id) do
      {:ok, search_result} ->
        render(conn, "result_snapshot.html", search_result_html: search_result.html_cache)

      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end
end
