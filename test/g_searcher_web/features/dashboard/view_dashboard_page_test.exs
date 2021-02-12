defmodule GSearcherWeb.HomePage.ViewDashboardPageTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    report_upload: ".report-upload",
    report_list: ".report-index",
    report_titles: ".table__item--report-title p"
  }

  feature "view user dashboard", %{session: session} do
    user = insert(:user)

    session
    |> sign_in_as(user)
    |> visit(Routes.dashboard_path(GSearcherWeb.Endpoint, :index))
    |> assert_has(css(@selectors[:report_upload]))
    |> assert_has(css(@selectors[:report_list]))
  end

  feature "view list of user reports", %{session: session} do
    user = insert(:user)

    parsing_report = insert(:report, title: "Report 1", user: user)
    parsing_search_result = insert(:only_search_term, search_term: "Pogo Jumping")

    _report_search_result1 =
      insert(:report_search_result, report: parsing_report, search_result: parsing_search_result)

    completed_report = insert(:report, title: "Report 2", user: user)
    completed_search_result = insert(:search_result, search_term: "Skiing")

    _report_search_result2 =
      insert(:report_search_result,
        report: completed_report,
        search_result: completed_search_result
      )

    session
    |> sign_in_as(user)
    |> visit(Routes.dashboard_path(GSearcherWeb.Endpoint, :index))
    |> assert_has(css(@selectors[:report_titles], text: parsing_report.title))
    |> assert_has(css(@selectors[:report_titles], text: completed_report.title))
  end
end
