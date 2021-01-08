defmodule GSearcher.SearchResults.SearchWorker do
  use Oban.Worker, queue: :events

  alias GSearcher.SearchResults

  @base_url "https://www.google.com/search?q="
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id, "keyword" => keyword}}) do
    search_result_params =
      keyword
      |> search_keyword()
      |> extract_search_result_details()

    {:ok, _} = SearchResults.update_search_result(id, search_result_params)

    :ok
  end

  defp search_keyword(keyword) do
    encoded_keyword = URI.encode(keyword)

    headers = ["user-agent": @user_agent]

    HTTPoison.start()

    {:ok, response} = HTTPoison.get("#{@base_url}#{encoded_keyword}", headers)

    handle_response(response)
  end

  defp handle_response(%{status_code: 200, body: body}), do: body

  defp extract_search_result_details(response_body) do
    %{
      number_of_results_on_page: 1,
      number_of_top_advertisers: 0,
      total_number_of_advertisers: 0,
      total_number_results: 1,
      top_advertiser_urls: ["sample"],
      advertiser_urls: ["sample"],
      all_urls: ["sample"],
      html_cache: response_body
    }
  end
end
