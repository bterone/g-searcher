defmodule GSearcher.SearchResults.SearchResultParser do
  @top_ads "#tads a"
  @bottom_ads "#bottomads #tadsb a"
  @search_results "#search .g div div > a"
  @total_count "#result-stats"
  @url_link "href"

  @google_url "https://www.google.com/"

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
      |> Floki.attribute(@url_link)
      |> ignore_google_urls()

    {:ok, top_advertiser_urls}
  end

  defp fetch_regular_advertiser_urls(html_tree) do
    regular_advertiser_urls =
      html_tree
      |> Floki.find(@bottom_ads)
      |> Floki.attribute(@url_link)
      |> ignore_google_urls()

    {:ok, regular_advertiser_urls}
  end

  defp fetch_search_result_urls(html_tree) do
    search_result_urls =
      html_tree
      |> Floki.find(@search_results)
      |> Floki.attribute(@url_link)
      |> Enum.reject(fn url -> url == "#" end)

    {:ok, search_result_urls}
  end

  defp fetch_total_result_count(html_tree) do
    total_count =
      html_tree
      |> Floki.find(@total_count)
      |> Floki.text()
      # Removes any value in-between brackets (Eg: (0.52 seconds))
      |> String.replace(~r/\(.*\)/, "")
      # Removes any value that is not a digit (Eg: About 958,000 results => 958000)
      |> String.replace(~r/[^\d]/, "")
      |> String.to_integer()

    {:ok, total_count}
  end

  defp ignore_google_urls(urls) do
    Enum.reject(urls, fn url -> google_url?(url) end)
  end

  defp google_url?(@google_url <> _), do: true
  defp google_url?(_), do: false
end
