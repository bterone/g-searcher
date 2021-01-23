defmodule GSearcherWeb.HomePage.ViewDashboardPageTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    report_upload: ".report-upload",
    report_list: ".report-index",
    report_table: ".table-report"
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

    parsing_report = insert(:report, title: "Report 1")
    parsing_search_result = insert(:only_search_term, search_term: "Pogo Jumping")

    _report_search_result1 =
      insert(:report_search_result, report: parsing_report, search_result: parsing_search_result)

    completed_report = insert(:report, title: "Report 2")
    completed_search_result = insert(:search_result, search_term: "Skiing")

    _report_search_result2 =
      insert(:report_search_result,
        report: completed_report,
        search_result: completed_search_result
      )

    # TODO: Check for report details in test when working on frontend
    session
    |> sign_in_as(user)
    |> visit(Routes.dashboard_path(GSearcherWeb.Endpoint, :index))
    |> assert_has(css(@selectors[:report_table]))
  end
end
