defmodule GSearcherWeb.HomePage.ViewReportPageTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    report_summary_card: ".card .card__body h2",
    report_summary_counter: ".card .card__body h1.card__counter",
    report_status_span: ".card-report-detail .card__header span",
    keyword_titles: ".table-search-result .table__body .table__item--keyword p"
  }

  feature "view report summary", %{session: session} do
    user = insert(:user)

    report = insert(:report, user: user)

    search_result =
      insert(:search_result, search_term: "Jumping Jacks", number_of_top_advertisers: 5)

    _report_search_result =
      insert(:report_search_result, report: report, search_result: search_result)

    session
    |> sign_in_as(user)
    |> visit(Routes.report_path(GSearcherWeb.Endpoint, :show, report.id))
    |> assert_has(css(@selectors[:report_summary_card], text: report.title))
    |> assert_has(css(@selectors[:report_summary_counter], count: 2, text: "1"))
    |> assert_has(css(@selectors[:report_summary_counter], text: "5"))
    |> assert_has(css(@selectors[:report_status_span], text: "Completed"))
  end

  feature "view search result table", %{session: session} do
    user = insert(:user)

    report = insert(:report, user: user)
    search_result = insert(:search_result, search_term: "Are crayons edible?")

    _report_search_result =
      insert(:report_search_result, report: report, search_result: search_result)

    session
    |> sign_in_as(user)
    |> visit(Routes.report_path(GSearcherWeb.Endpoint, :show, report.id))
    |> assert_has(css(@selectors[:keyword_titles], text: search_result.search_term))
  end
end
