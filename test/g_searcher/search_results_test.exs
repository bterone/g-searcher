defmodule GSearcher.SearchResultsTest do
  use GSearcher.DataCase

  alias GSearcher.SearchResults
  alias GSearcher.SearchResults.{ReportSearchResult, SearchResult}

  describe "create_search_result/1" do
    test "creates search result given valid attributes" do
      search_result_params = params_for(:search_result, search_term: "Test Search")

      assert {:ok, search_result} = SearchResults.create_search_result(search_result_params)
      assert search_result.search_term == "Test Search"

      assert [search_result_in_db] = Repo.all(SearchResult)
      assert search_result_in_db == search_result
    end

    test "returns invalid changeset given invalid attributes" do
      assert {:error, changeset} = SearchResults.create_search_result(%{})

      assert errors_on(changeset) == %{
               search_term: ["can't be blank"]
             }
    end
  end

  describe "get_search_result/1" do
    test "returns {:ok, search_result} given a valid ID" do
      search_result = insert(:search_result)

      assert SearchResults.get_search_result(search_result.id) == {:ok, search_result}
    end

    test "returns {:error, :not_found} given an invalid ID" do
      assert SearchResults.get_search_result(0) == {:error, :not_found}
    end
  end

  describe "update_search_result/2" do
    test "updates search result given a valid ID and attributes" do
      search_result = insert(:search_result)
      search_result_params = params_for(:search_result, html_cache: "TEST")

      assert {:ok, _} = SearchResults.update_search_result(search_result, search_result_params)

      [search_result_in_db] = Repo.all(SearchResult)

      assert search_result_in_db.number_of_results_on_page == search_result_params.number_of_results_on_page
      assert search_result_in_db.number_of_top_advertisers == search_result_params.number_of_top_advertisers
      assert search_result_in_db.total_number_of_advertisers == search_result_params.total_number_of_advertisers
      assert search_result_in_db.total_number_results == search_result_params.total_number_results
      assert search_result_in_db.html_cache == search_result_params.html_cache
    end
  end

  describe "associate_search_result_to_report/1" do
    test "creates report search result given valid attributes" do
      report = insert(:report)
      search_result = insert(:search_result)

      assert {:ok, report_search_result} =
               SearchResults.associate_search_result_to_report(report.id, search_result.id)

      assert [report_search_result_in_db] = Repo.all(ReportSearchResult)
      assert report_search_result_in_db.report_id == report.id
      assert report_search_result_in_db.search_result_id == search_result.id
    end

    test "returns invalid changeset given report association is invalid" do
      search_result = insert(:search_result)

      assert {:error, changeset} =
               SearchResults.associate_search_result_to_report(0, search_result.id)

      assert errors_on(changeset) == %{
               report: ["does not exist"]
             }
    end

    test "returns invalid changeset given search_result association is invalid" do
      report = insert(:report)

      assert {:error, changeset} = SearchResults.associate_search_result_to_report(report.id, 0)

      assert errors_on(changeset) == %{
               search_result: ["does not exist"]
             }
    end
  end
end
