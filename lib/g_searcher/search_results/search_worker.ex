defmodule GSearcher.SearchResults.SearchWorker do
  use Oban.Worker, queue: :events, max_attempts: 2

  alias GSearcher.SearchResults
  alias GSearcher.SearchResults.SearchResultParser

  @base_url "https://www.google.com/search?q="
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id, "keyword" => keyword}}) do
    with {:ok, search_result} <- SearchResults.get_search_result(id),
         {:ok, response_body} <- search_keyword(keyword),
         {:ok, search_result_params} <- extract_search_result_details(response_body),
         {:ok, _} <- SearchResults.update_search_result(search_result, search_result_params) do
      :ok
    else
      {:error, :http_client_error, reason} ->
        {:error, "HTTP Client error: #{inspect(reason)}"}

      {:error, :not_found} ->
        {:error, "Search Result not found for: ID: #{id}, Keyword: #{keyword}"}

      {:error, %Ecto.Changeset{}} ->
        {:error, "Failed to update keyword: ID: #{id}, Keyword: #{keyword}"}
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
end
