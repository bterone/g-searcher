defmodule GSearcher.SearchResults.SearchWorker do
  use Oban.Worker, queue: :events, max_attempts: 2

  alias Ecto.Multi
  alias GSearcher.{Repo, SearchResults}
  alias GSearcher.SearchResults.SearchResultParser

  @base_url "https://www.google.com/search?q="
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id, "keyword" => keyword}}) do
    with {:ok, search_result} <- SearchResults.get_search_result(id),
         {:ok, response_body} <- search_keyword(keyword),
         {:ok, search_result_details} <- extract_search_result_details(response_body),
         {:ok, _} <- save_search_results(search_result, search_result_details) do
      :ok
    else
      {:error, :http_client_error, reason} ->
        {:error, "HTTP Client error: #{inspect(reason)}"}

      {:error, :not_found} ->
        {:error, "Search Result not found for: ID: #{id}, Keyword: #{keyword}"}

      {:error, :failed_to_parse_html, reason} ->
        {:error, "Failed to parse HTML with reason: #{inspect(reason)}"}

      {:error, step, changeset, _} ->
        {:error,
         "Failed to save search_result at step: #{inspect(step)}, changeset: #{inspect(changeset)}"}
    end
  end

  defp search_keyword(keyword) do
    encoded_keyword = URI.encode(keyword)

    headers = ["user-agent": @user_agent]

    case HTTPoison.get("#{@base_url}#{encoded_keyword}", headers) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:error, %{reason: reason}} -> {:error, :http_client_error, reason}
    end
  end

  defp extract_search_result_details(response_body) do
    SearchResultParser.parse(response_body)
  end

  defp save_search_results(
         search_result,
         %{
           top_advertiser_urls: top_ads,
           regular_advertiser_urls: regular_ads,
           search_result_urls: search_result_urls
         } = search_result_details
       ) do
    Multi.new()
    |> Multi.run(:update_search_result, fn _, _ ->
      SearchResults.update_search_result(search_result, search_result_details)
    end)
    |> Multi.run(:create_top_ads, fn _, _ ->
      SearchResults.create_search_result_url(search_result, top_ads)
    end)
    |> Multi.run(:create_regular_ads, fn _, _ ->
      SearchResults.create_search_result_url(search_result, regular_ads)
    end)
    |> Multi.run(:create_search_result_urls, fn _, _ ->
      SearchResults.create_search_result_url(search_result, search_result_urls)
    end)
    |> Repo.transaction()
  end
end
