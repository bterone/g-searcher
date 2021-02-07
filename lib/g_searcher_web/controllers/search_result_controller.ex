defmodule GSearcherWeb.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.SearchResults
  alias GSearcherWeb.ErrorHandler

  def show(conn, %{"id" => search_result_id}) do
    user = conn.assigns.current_user

    case SearchResults.get_user_search_result(search_result_id, user.id) do
      {:ok, search_result} ->
        render(conn, "show.html", search_result: search_result)

      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end

  def result_snapshot(conn, %{"id" => search_result_id}) do
    user = conn.assigns.current_user

    case SearchResults.get_user_search_result(search_result_id, user.id) do
      {:ok, search_result} ->
        render(conn, "result_snapshot.html", search_result_html: search_result.html_cache)

      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end
end
