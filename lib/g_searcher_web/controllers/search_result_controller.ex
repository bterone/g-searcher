defmodule GSearcherWeb.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.{SearchResults, SearchResultURLs}
  alias GSearcherWeb.ErrorHandler
  alias GSearcherWeb.Helpers.SearchHelper
  alias GSearcherWeb.Validators.{ParamsValidator, SearchResultParams}

  def index(conn, %{"query" => query}) when is_binary(query) do
    %{id: user_id} = conn.assigns.current_user

    with {:ok, query_params} <- SearchHelper.parse_query(query),
         {:ok, validated_params} <-
           ParamsValidator.validate(query_params, as: SearchResultParams),
         search_results <- SearchResults.list_search_results_by_user_id(user_id, validated_params) do
      render(conn, "index.html", search_results: search_results)
    else
      {:error, :invalid_params, changeset} ->
        search_results = SearchResults.list_search_results_by_user_id(user_id)
        error_message = ErrorHandler.build_changeset_error_message(changeset)

        conn
        |> put_flash(:error, error_message)
        |> render("index.html", search_results: search_results)
    end
  end

  def index(conn, _params) do
    %{id: user_id} = conn.assigns.current_user

    search_results = SearchResults.list_search_results_by_user_id(user_id)

    render(conn, "index.html", search_results: search_results)
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
