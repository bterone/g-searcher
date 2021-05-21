defmodule GSearcher.SearchResultURLsTest do
  use GSearcher.DataCase

  alias GSearcher.SearchResultURLs

  describe "get_by_search_result_id/1" do
    test "returns search result urls given a valid search result ID" do
      search_result = insert(:search_result)

      search_result_url =
        insert(:search_result_url, search_result: search_result) |> forget_associations()

      _random_url = insert(:search_result_url)

      assert SearchResultURLs.get_by_search_result_id(search_result.id) ==
               {:ok, [search_result_url]}
    end

    test "returns an empty list given an invalid search result ID" do
      assert SearchResultURLs.get_by_search_result_id(0) == {:ok, []}
    end
  end
end
