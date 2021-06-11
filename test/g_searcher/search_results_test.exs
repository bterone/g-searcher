defmodule GSearcher.SearchResultsTest do
  use GSearcher.DataCase

  import ExUnit.CaptureLog

  alias GSearcher.SearchResults
  alias GSearcher.SearchResults.{ReportSearchResult, SearchResult, SearchResultURL}

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
      search_result = insert(:search_result) |> forget_associations()

      assert SearchResults.get_search_result(search_result.id) == {:ok, search_result}
    end

    test "returns {:error, :not_found} given an invalid ID" do
      assert SearchResults.get_search_result(0) == {:error, :not_found}
    end
  end

  describe "get_user_search_result/2" do
    test "returns {:ok, search_result} given a valid ID and belongs to user" do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result) |> forget_associations()

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      assert SearchResults.get_user_search_result(search_result.id, user.id) ==
               {:ok, search_result}
    end

    test "returns {:error, :not_found} given search result does NOT belong to user" do
      user = insert(:user)
      search_result = insert(:search_result)

      assert SearchResults.get_user_search_result(search_result.id, user.id) ==
               {:error, :not_found}
    end

    test "returns {:error, :not_found} given an invalid ID" do
      user = insert(:user)

      assert SearchResults.get_user_search_result(0, user.id) == {:error, :not_found}
    end
  end

  describe "get_search_results_from_report/2" do
    test "returns {:ok, search_result} given a valid ID" do
      report = insert(:report)
      search_result = insert(:search_result) |> forget_associations()

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      _invalid_report_result = insert(:report_search_result)

      assert SearchResults.get_search_results_from_report(report.id) == {:ok, [search_result]}
    end

    test "returns {:error, :not_found} given an invalid ID" do
      assert SearchResults.get_search_results_from_report(0) == {:error, :not_found}
    end
  end

  describe "list_search_results_by_user_id/2" do
    test "returns list of search_results" do
      user = insert(:user)

      report1 = insert(:report, user: user)
      report2 = insert(:report, user: user)
      search_result1 = insert(:search_result) |> forget_associations()
      search_result2 = insert(:search_result) |> forget_associations()

      _report_search_result_1 =
        insert(:report_search_result, report: report1, search_result: search_result1)

      _report_search_result_2 =
        insert(:report_search_result, report: report2, search_result: search_result2)

      _invalid_report_result = insert(:report_search_result)

      assert SearchResults.list_search_results_by_user_id(user.id) == [
               search_result1,
               search_result2
             ]
    end

    test "returns list of search_results given query params" do
      user = insert(:user)

      report1 = insert(:report, user: user)
      report2 = insert(:report, user: user)

      search_result1 =
        insert(:search_result, search_term: "The quick fox") |> forget_associations()

      search_result2 =
        insert(:search_result, search_term: "The lazy dog") |> forget_associations()

      _report_search_result_1 =
        insert(:report_search_result, report: report1, search_result: search_result1)

      _report_search_result_2 =
        insert(:report_search_result, report: report2, search_result: search_result2)

      assert SearchResults.list_search_results_by_user_id(user.id, "quick") == [search_result1]
    end
  end

  describe "update_search_result/2" do
    test "updates search result given a valid ID and attributes" do
      search_result = insert(:search_result)
      search_result_params = params_for(:search_result, html_cache: "TEST")

      assert {:ok, _} = SearchResults.update_search_result(search_result, search_result_params)

      [search_result_in_db] = Repo.all(SearchResult)

      assert search_result_in_db.number_of_results_on_page ==
               search_result_params.number_of_results_on_page

      assert search_result_in_db.number_of_top_advertisers ==
               search_result_params.number_of_top_advertisers

      assert search_result_in_db.number_of_regular_advertisers ==
               search_result_params.number_of_regular_advertisers

      assert search_result_in_db.total_number_of_results ==
               search_result_params.total_number_of_results

      assert search_result_in_db.html_cache == search_result_params.html_cache
    end
  end

  describe "create_search_result_url/2" do
    test "creates search_result_urls given a search result and list of search_result_urls" do
      search_result = insert(:search_result)
      params_1 = params_for(:search_result_url, search_result: search_result)
      params_2 = params_for(:search_result_url, search_result: search_result)

      assert {:ok, _} =
               SearchResults.create_search_result_url(search_result, [params_1, params_2])

      [url_in_db_1, url_in_db_2] = Repo.all(SearchResultURL)

      assert url_in_db_1.title == params_1.title
      assert url_in_db_1.url == params_1.url

      assert url_in_db_2.title == params_2.title
      assert url_in_db_2.url == params_2.url
    end

    test "creates search_result_urls given a list of invalid search result urls" do
      search_result = insert(:search_result)
      result_url_params = params_for(:search_result_url, search_result: search_result)

      stub(SearchResultURL, :create_changeset, fn _, _ -> %Ecto.Changeset{valid?: false} end)

      assert capture_log(fn ->
               assert SearchResults.create_search_result_url(search_result, [result_url_params]) ==
                        {:ok, :partially_saved_urls}
             end) =~ "partially_saved_urls: Some URLs could not be saved"

      assert Repo.all(SearchResultURL) == []
    end
  end

  describe "create_search_result_url/1" do
    test "creates search_result_url given valid attributes" do
      search_result = insert(:search_result)
      search_result_url_params = params_for(:search_result_url, search_result: search_result)

      assert {:ok, _} = SearchResults.create_search_result_url(search_result_url_params)

      [url_in_db] = Repo.all(SearchResultURL)

      assert url_in_db.title == search_result_url_params.title
      assert url_in_db.url == search_result_url_params.url
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
