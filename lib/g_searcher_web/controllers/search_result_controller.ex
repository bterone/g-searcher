defmodule GSearcherWeb.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.{SearchResults, SearchResultURLs}
  alias GSearcherWeb.ErrorHandler

  def show(conn, %{"id" => search_result_id}) do
    user = conn.assigns.current_user

    with {:ok, search_result} <- SearchResults.get_user_search_result(search_result_id, user.id),
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
    user = conn.assigns.current_user

    case SearchResults.get_user_search_result(search_result_id, user.id) do
      {:ok, search_result} ->
        render(conn, "result_snapshot.html", search_result_html: search_result.html_cache)

      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end
end
