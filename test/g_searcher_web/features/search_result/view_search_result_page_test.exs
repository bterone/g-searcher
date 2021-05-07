defmodule GSearcherWeb.HomePage.ViewSearchResultPageTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    search_result_title_card: ".card__container--lead .card__body h2",
    search_result_counter: ".card .card__body h1.card__counter",
    search_result_title: ".table-search-result-url .table__item--title p",
    search_result_advertiser_urls: ".table-search-result-url .table__item--advertiser-url p"
  }

  feature "view search result summary", %{session: session} do
    user = insert(:user)

    report = insert(:report, user: user)

    search_result =
      insert(:search_result, search_term: "Jumping Jacks", total_number_of_results: 1_000_000)

    _report_search_result =
      insert(:report_search_result, report: report, search_result: search_result)

    session
    |> sign_in_as(user)
    |> visit(Routes.search_result_path(GSearcherWeb.Endpoint, :show, search_result.id))
    |> assert_has(css(@selectors[:search_result_title_card], text: search_result.search_term))
    |> assert_has(css(@selectors[:search_result_counter], text: "1 Million"))
  end

  feature "view search result table", %{session: session} do
    user = insert(:user)

    report = insert(:report, user: user)

    search_result_url =
      build(:search_result_url, title: "Some Website", url: "www.website.com", is_top_ad: true)

    search_result = insert(:search_result, search_result_urls: [search_result_url])

    _report_search_result =
      insert(:report_search_result, report: report, search_result: search_result)

    session
    |> sign_in_as(user)
    |> visit(Routes.search_result_path(GSearcherWeb.Endpoint, :show, search_result.id))
    |> assert_has(css(@selectors[:search_result_title], text: "Some Website"))
    |> assert_has(css(@selectors[:search_result_advertiser_urls], text: "www.website.com"))
  end
end
