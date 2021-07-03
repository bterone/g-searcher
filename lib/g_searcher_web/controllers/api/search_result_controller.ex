defmodule GSearcherWeb.API.SearchResultController do
  use GSearcherWeb, :controller

  alias GSearcher.{SearchResults, SearchResultURLs}
  alias GSearcherWeb.ErrorHandler
  alias GSearcherWeb.Validators.{ParamsValidator, SearchResultParams}

  def index(conn, params) when is_map(params) do
    %{id: user_id} = conn.assigns.user

    with {:ok, validated_params} <-
           ParamsValidator.validate(params, as: SearchResultParams),
         search_results <- SearchResults.list_search_results_by_user_id(user_id, validated_params) do
      render(conn, "index.json", %{search_results: search_results})
    else
      {:error, :invalid_params, changeset} ->
        changeset_errors = ErrorHandler.build_changeset_error_message(changeset)

        conn
        |> put_status(:bad_request)
        |> ErrorHandler.render_error_json(:bad_request, changeset_errors)
    end
  end

  def index(conn, _params) do
    %{id: user_id} = conn.assigns.user

    search_results = SearchResults.list_search_results_by_user_id(user_id)

    conn
    |> put_status(:ok)
    |> render("index.json", %{search_results: search_results})
  end

  def show(conn, %{"id" => search_result_id}) do
    %{id: user_id} = conn.assigns.user

    with {:ok, search_result} <- SearchResults.get_user_search_result(search_result_id, user_id),
         {:ok, search_result_urls} <- SearchResultURLs.get_by_search_result_id(search_result_id) do
      render(conn, "show.json",
        search_result: search_result,
        search_result_urls: search_result_urls
      )
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> ErrorHandler.render_error_json(:not_found)
    end
  end
end
