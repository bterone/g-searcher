defmodule GSearcherWeb.DashboardController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcher.SearchResults.Report

  def index(conn, %{create_report: %Report{} = report}) do
    reports = Reports.list_reports_by_user(conn.assigns.current_user.id)

    render(conn, "index.html", create_report: report, reports: reports)
  end

  def index(conn, _params) do
    empty_report_changeset = Report.create_changeset(%{})
    reports = Reports.list_reports_by_user(conn.assigns.current_user.id)

    render(conn, "index.html", create_report: empty_report_changeset, reports: reports)
  end
end
