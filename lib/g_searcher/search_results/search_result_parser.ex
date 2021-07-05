defmodule GSearcher.SearchResults.SearchResultParser do
  @total_count "#result-stats"

  @top_ads %{link: "#tads a", title: "[role=heading]"}
  @search_results %{link: "#search .g div div > a", title: "h3"}
  @bottom_ads %{link: "#bottomads #tadsb a", title: "[role=heading]"}

  @url_link "href"

  @google_url "https://www.google.com/"

  @spec parse(String.t()) ::
          {:ok,
           %{
             top_advertiser_urls: [%{title: String.t(), url: String.t()}],
             regular_advertiser_urls: [%{title: String.t(), url: String.t()}],
             search_result_urls: [%{title: String.t(), url: String.t()}],
             number_of_top_advertisers: integer(),
             number_of_regular_advertisers: integer(),
             number_of_results_on_page: integer(),
             total_number_of_results: integer(),
             html_cache: String.t()
           }}
          | {:error, :failed_to_parse_html, String.t()}
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
      |> build_result_params(@top_ads, %{is_top_ad: true})
      |> ignore_google_urls()

    %{
      top_advertiser_urls: top_advertiser_urls,
      number_of_top_advertisers: Enum.count(top_advertiser_urls)
    }
  end

  defp fetch_regular_advertiser_urls(html_tree) do
    regular_advertiser_urls =
      html_tree
      |> build_result_params(@bottom_ads, %{is_regular_ad: true})
      |> ignore_google_urls()

    %{
      regular_advertiser_urls: regular_advertiser_urls,
      number_of_regular_advertisers: Enum.count(regular_advertiser_urls)
    }
  end

  defp fetch_search_result_urls(html_tree) do
    search_result_urls =
      html_tree
      |> build_result_params(@search_results)
      |> Enum.reject(fn %{title: title, url: url} ->
        url == "#" || title == ""
      end)

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

  defp build_result_params(html_tree, selector, optional_params \\ %{}) do
    html_tree
    |> Floki.find(selector.link)
    |> Enum.map(fn {_, _, child_nodes} = items ->
      [url] = Floki.attribute(items, @url_link)

      title =
        child_nodes
        |> Floki.find(selector.title)
        |> Floki.text()

      Map.merge(%{title: title, url: url}, optional_params)
    end)
  end

  defp ignore_google_urls(urls) do
    Enum.reject(urls, fn %{title: _, url: url} -> google_url?(url) end)
  end

  defp google_url?(@google_url <> _), do: true
  defp google_url?(url) when is_binary(url), do: false
end
