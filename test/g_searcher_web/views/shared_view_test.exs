defmodule GSearcherWeb.SharedViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.SharedView

  describe "status/1" do
    test "returns completed status if search result has HTML cache" do
      search_result = insert(:search_result, html_cache: "<html><body><p>Hello</p></body></html>")

      assert SharedView.status(search_result) == "Completed"
    end

    test "returns searching status if search result has NO HTML cache" do
      search_result = insert(:search_result, html_cache: nil)

      assert SharedView.status(search_result) == "Searching"
    end
  end
end
