defmodule GSearcherWeb.DashboardViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.DashboardView

  describe "report_status/1" do
    test "returns parsing if report pending searches" do
      report = insert(:report)

      search_term = insert(:only_search_term)
      insert(:report_search_result, report: report, search_result: search_term)

      assert DashboardView.report_status(report) == "Parsing"
    end

    test "returns completed if report has all keywords searched" do
      report = insert(:report)

      search_result = insert(:search_result)
      insert(:report_search_result, report: report, search_result: search_result)

      assert DashboardView.report_status(report) == "Completed"
    end
  end
end
