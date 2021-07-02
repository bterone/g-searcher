defmodule GSearcherWeb.API.SearchResultView do
  use GSearcherWeb, :view

  alias GSearcherWeb.{NumberHelpers, SharedView}

  # TODO: Introduce pagination in #66
  def render("index.json", %{search_results: search_results}) do
    search_result_data =
      Enum.map(search_results, fn search_result ->
        build_search_result_data(search_result)
      end)

    %{
      data: search_result_data
    }
  end

  def render("show.json", %{search_result: search_result, search_result_urls: search_result_urls}) do
    search_result_url_data =
      Enum.map(search_result_urls, fn search_result_url ->
        %{
          type: "search_result_url",
          id: search_result_url.id,
          attributes: %{
            title: search_result_url.title,
            url: search_result_url.url,
            is_top_ad: search_result_url.is_top_ad,
            is_regular_ad: search_result_url.is_regular_ad
          }
        }
      end)

    %{
      data: search_result_url_data,
      included: build_search_result_data(search_result)
    }
  end

  defp build_search_result_data(search_result) do
    %{
      type: "search_result",
      id: search_result.id,
      attributes: %{
        keyword: search_result.search_term,
        status: SharedView.status(search_result),
        top_advertiser_count: search_result.number_of_top_advertisers,
        regular_advertiser_count: search_result.number_of_regular_advertisers,
        page_result_count: search_result.number_of_results_on_page,
        total_result_count: NumberHelpers.number_to_human(search_result.total_number_of_results)
      }
    }
  end
end
