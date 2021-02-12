defmodule GSearcherWeb.DashboardController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcher.SearchResults.Report

  def index(conn, params) do
    create_report = params[:create_report] || Report.create_changeset(%{})
    reports = Reports.list_reports_by_user(conn.assigns.current_user.id)

    render(conn, "index.html", create_report: create_report, reports: reports)
  end
end
