defmodule GSearcherWeb.ReportViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.ReportView

  describe "status/1" do
    test "returns completed status if search result has HTML cache" do
      search_result = insert(:search_result, html_cache: "<html><body><p>Hello</p></body></html>")

      assert ReportView.status(search_result) == "Completed"
    end

    test "returns searching status if search result has NO HTML cache" do
      search_result = insert(:search_result, html_cache: nil)

      assert ReportView.status(search_result) == "Searching"
    end
  end

  describe "modifer_class/1" do
    test "returns downcased string" do
      assert ReportView.modifer_class("Searching") == "searching"
    end
  end
end
