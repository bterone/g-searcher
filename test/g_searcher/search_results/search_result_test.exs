defmodule GSearcher.SearchResults.SearchResultTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.SearchResults.SearchResult

  describe "create_keyword_changeset/2" do
    test "returns valid changeset given valid params" do
      params = %{search_term: "Test Keyword"}

      changeset = SearchResult.create_keyword_changeset(params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are empty" do
      changeset = SearchResult.create_keyword_changeset(%{search_term: ""})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               search_term: ["can't be blank"]
             }
    end
  end

  describe "update_search_result_changeset/2" do
    test "returns valid changeset given valid params" do
      params = params_for(:search_result)

      changeset =
        SearchResult.update_search_result_changeset(%SearchResult{search_term: "Test"}, params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are empty" do
      search_result = insert(:search_result)

      changeset =
        SearchResult.update_search_result_changeset(search_result, %{
          total_number_of_results: "",
          number_of_results_on_page: "",
          search_result_urls: [],
          html_cache: "",
          number_of_top_advertisers: "",
          number_of_regular_advertisers: ""
        })

      refute changeset.valid?

      assert errors_on(changeset) == %{
               total_number_of_results: ["can't be blank"],
               number_of_results_on_page: ["can't be blank"],
               html_cache: ["can't be blank"],
               number_of_top_advertisers: ["can't be blank"],
               number_of_regular_advertisers: ["can't be blank"]
             }
    end
  end
end
