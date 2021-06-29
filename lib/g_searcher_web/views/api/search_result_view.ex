defmodule GSearcherWeb.API.SearchResultView do
  use GSearcherWeb, :view

  alias GSearcherWeb.{NumberHelpers, SharedView}

  # TODO: Introduce pagination in #66
  def render("index.json", %{search_results: search_results}) do
    search_result_data = Enum.map(search_results, fn search_result ->
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
    end)

    %{
      data: search_result_data
    }
  end
end
