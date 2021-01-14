defmodule GSearcher.SearchResults.SearchResultParser do
  @top_ads "#tads a"
  @bottom_ads "#bottomads #tadsb a"
  @search_results "#search .g div div > a"
  @total_count "#result-stats"
  @url_link "href"

  @google_url "https://www.google.com/"

  def parse(all_html) do
    case Floki.parse_document(all_html) do
      {:ok, html_tree} ->
        results =
          [
            Task.async(fn -> fetch_top_advertiser_urls(html_tree) end),
            Task.async(fn -> fetch_regular_advertiser_urls(html_tree) end),
            Task.async(fn -> fetch_search_result_urls(html_tree) end),
            Task.async(fn -> fetch_total_result_count(html_tree) end)
          ]
          |> Task.yield_many()
          |> Enum.map(fn {_, {:ok, result}} -> result end)
          |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)

        {:ok, Map.merge(results, %{html_cache: all_html})}

      {:error, reason} ->
        {:error, :failed_to_parse_html, reason}
    end
  end

  defp fetch_top_advertiser_urls(html_tree) do
    top_advertiser_urls =
      html_tree
      |> Floki.find(@top_ads)
      |> Floki.attribute(@url_link)
      |> ignore_google_urls()

    %{
      top_advertiser_urls: top_advertiser_urls,
      number_of_top_advertisers: Enum.count(top_advertiser_urls)
    }
  end

  defp fetch_regular_advertiser_urls(html_tree) do
    regular_advertiser_urls =
      html_tree
      |> Floki.find(@bottom_ads)
      |> Floki.attribute(@url_link)
      |> ignore_google_urls()

    %{
      regular_advertiser_urls: regular_advertiser_urls,
      number_of_regular_advertisers: Enum.count(regular_advertiser_urls)
    }
  end

  defp fetch_search_result_urls(html_tree) do
    search_result_urls =
      html_tree
      |> Floki.find(@search_results)
      |> Floki.attribute(@url_link)
      |> Enum.reject(fn url -> url == "#" end)

    %{
      search_result_urls: search_result_urls,
      number_of_results_on_page: Enum.count(search_result_urls)
    }
  end

  defp fetch_total_result_count(html_tree) do
    case Floki.find(html_tree, @total_count) do
      [] ->
        %{total_number_of_results: 0}

      element ->
        total_count =
          element
          |> Floki.text()
          # Removes any value in-between brackets (Eg: (0.52 seconds))
          |> String.replace(~r/\(.*\)/, "")
          # Removes any value that is not a digit (Eg: About 958,000 results => 958000)
          |> String.replace(~r/[^\d]/, "")
          |> String.to_integer()

        %{total_number_of_results: total_count}
    end
  end

  defp ignore_google_urls(urls) do
    Enum.reject(urls, &google_url?/1)
  end

  defp google_url?(@google_url <> _), do: true
  defp google_url?(_), do: false
end
