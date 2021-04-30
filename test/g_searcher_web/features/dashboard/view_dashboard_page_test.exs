defmodule GSearcherWeb.HomePage.ViewDashboardPageTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    form_report_title: "input#report_title",
    form_report_csv: "input#report_csv",
    form_report_submit: ".form-report__action button",
    report_upload: ".upload-report",
    report_list: ".report-list",
    report_titles: ".table__item--report-title p",
    success_notification: ".alert--info",
    upload_report_button: ".form-report__button"
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

  feature "uploads report form when filling report details", %{session: session} do
    user = insert(:user)

    report_details = build(:report, title: "Example 1")

    session
    |> sign_in_as(user)
    |> visit(Routes.dashboard_path(GSearcherWeb.Endpoint, :index))
    |> upload_report(report_details)
    |> assert_has(css(@selectors[:success_notification], text: "Report generated successfully"))
    |> assert_has(css(@selectors[:report_titles], text: "Example 1"))
  end

  defp upload_report(page, report) do
    page
    |> click(css(@selectors[:upload_report_button]))
    |> fill_in(css(@selectors[:form_report_title]), with: report.title)
    |> attach_file(css(@selectors[:form_report_csv]), path: report.csv_path)
    |> click(css(@selectors[:form_report_submit]))
  end
end
