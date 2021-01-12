defmodule GSearcher.SearchResults.SearchResultParser do
  @top_ads "#tads > a"
  @bottom_ads "#bottomads > a"
  @search_results "#search > a"
  @total_count "#result-stats"
  @url "href"

  def parse(all_html) do
    with {:ok, html_tree} <- Floki.parse_document(all_html),
         {:ok, top_advertiser_urls} <- fetch_top_advertiser_urls(html_tree),
         {:ok, regular_advertiser_urls} <- fetch_regular_advertiser_urls(html_tree),
         {:ok, search_result_urls} <- fetch_search_result_urls(html_tree),
         {:ok, total_number_of_results} <- fetch_total_result_count(html_tree) do
      {:ok,
       %{
         number_of_results_on_page: Enum.count(search_result_urls),
         number_of_top_advertisers: Enum.count(top_advertiser_urls),
         number_of_regular_advertisers: Enum.count(regular_advertiser_urls),
         search_result_urls: search_result_urls,
         top_advertiser_urls: top_advertiser_urls,
         regular_advertiser_urls: regular_advertiser_urls,
         total_number_of_results: total_number_of_results,
         html_cache: all_html
       }}
    else
      _ ->
        {:error, :failed_to_parse_html}
    end
  end

  defp fetch_top_advertiser_urls(html_tree) do
    top_advertiser_urls =
      html_tree
      |> Floki.find(@top_ads)
      |> Floki.attribute(@url)

    {:ok, top_advertiser_urls}
  end

  defp fetch_regular_advertiser_urls(html_tree) do
    regular_advertiser_urls =
      html_tree
      |> Floki.find(@bottom_ads)
      |> Floki.attribute(@url)

    {:ok, regular_advertiser_urls}
  end

  defp fetch_search_result_urls(html_tree) do
    search_result_urls =
      html_tree
      |> Floki.find(@search_results)
      |> Floki.attribute(@url)

    {:ok, search_result_urls}
  end

  defp fetch_total_result_count(_html_tree) do
    1
  end
end
