defmodule GSearcherWeb.DashboardController do
  use GSearcherWeb, :controller

  alias GSearcher.Search.Report

  def index(conn, _params) do
    report_changeset = Report.changeset(%{})
    render(conn, "index.html", report: report_changeset)
  end
end
