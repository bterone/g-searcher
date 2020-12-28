defmodule GSearcherWeb.DashboardController do
  use GSearcherWeb, :controller

  alias GSearcher.SearchResults.Report

  def index(conn, _params) do
    report_changeset = Report.create_changeset(%{})
    render(conn, "index.html", report: report_changeset)
  end
end
