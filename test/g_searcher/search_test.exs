defmodule GSearcher.SearchTest do
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
