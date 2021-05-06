defmodule GSearcher.SearchResults.SearchResultURLTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.SearchResults.SearchResultURL

  describe "create_changeset/2" do
    test "returns valid changeset given valid params" do
      %{id: search_result_id} = insert(:search_result)
      params = %{title: "Example", url: "www.example.com", search_result_id: search_result_id}

      changeset = SearchResultURL.create_changeset(params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are empty" do
      params = %{}

      changeset = SearchResultURL.create_changeset(params)

      assert errors_on(changeset) == %{
        title: ["can't be blank"],
        url: ["can't be blank"],
        search_result_id: ["can't be blank"]
      }
    end

    test "returns invalid changeset if url is both top and regular ad" do
      %{id: search_result_id} = insert(:search_result)
      params = %{title: "Test", url: "test.com", search_result_id: search_result_id, is_top_ad: true, is_regular_ad: true}

      changeset = SearchResultURL.create_changeset(params)

      assert errors_on(changeset) == %{
        is_regular_ad: ["can't be both top and regular ad"]
      }
    end
  end
end
