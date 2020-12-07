defmodule GSearcher.Search.SearchResultTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Search.SearchResult

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

  describe "create_search_result_changeset/2" do
    test "returns valid changeset given valid params" do
      params = params_for(:search_result)

      changeset = SearchResult.create_search_result_changeset(params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are empty" do
      changeset =
        SearchResult.create_search_result_changeset(%{
          search_term: "",
          total_number_results: "",
          number_of_results_on_page: "",
          all_urls: [],
          html_cache: "",
          number_of_top_advertisers: "",
          total_number_of_advertisers: ""
        })

      refute changeset.valid?

      assert errors_on(changeset) == %{
               search_term: ["can't be blank"],
               total_number_results: ["can't be blank"],
               number_of_results_on_page: ["can't be blank"],
               all_urls: ["should have at least 1 item(s)"],
               html_cache: ["can't be blank"],
               number_of_top_advertisers: ["can't be blank"],
               total_number_of_advertisers: ["can't be blank"]
             }
    end
  end
end
