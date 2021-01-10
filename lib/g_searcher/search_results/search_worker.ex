defmodule GSearcher.SearchResults.SearchWorker do
  use Oban.Worker, queue: :events, max_attempts: 2

  alias GSearcher.SearchResults

  @base_url "https://www.google.com/search?q="
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id, "keyword" => keyword}}) do
    with {:ok, response_body} <- search_keyword(keyword),
         {:ok, search_result_params} <- extract_search_result_details(response_body),
         {:ok, _} <- SearchResults.update_search_result(id, search_result_params) do
      :ok
    else
      {:error, :http_client_error, reason} ->
        {:error, "HTTP Client error: #{inspect(reason)}"}

      {:error, %Ecto.Changeset{}} ->
        {:error, "Failed to update keyword: ID: #{id}, Keyword: #{keyword}"}
    end
  end

  defp search_keyword(keyword) do
    encoded_keyword = URI.encode(keyword)

    headers = ["user-agent": @user_agent]

    HTTPoison.start()

    case HTTPoison.get("#{@base_url}#{encoded_keyword}", headers) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:error, %{reason: reason}} -> {:error, :http_client_error, reason}
    end
  end

  # TODO: Actually extract the information in a separate service
  defp extract_search_result_details(response_body) do
    {:ok,
     %{
       number_of_results_on_page: 1,
       number_of_top_advertisers: 0,
       total_number_of_advertisers: 0,
       total_number_results: 1,
       top_advertiser_urls: ["sample"],
       advertiser_urls: ["sample"],
       all_urls: ["sample"],
       html_cache: response_body
     }}
  end
end
