defmodule GSearcherWeb.ReportViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.ReportView

  describe "modifer_class/1" do
    test "returns downcased string" do
      assert ReportView.modifer_class("Searching") == "searching"
    end
  end
end
