defmodule GSearcher.ReportsTest do
  use GSearcher.DataCase
  use Oban.Testing, repo: GSearcher.Repo

  alias GSearcher.{Reports, SearchResults}
  alias GSearcher.SearchResults.{SearchResult, SearchWorker}

  describe "create_report/3" do
    test "returns report given a valid CSV and valid information" do
      user = insert(:user)
      report = build(:report)

      assert {:ok, report} = Reports.create_report(user.id, report.title, report.csv_path)

      search_results = Repo.all(SearchResult)

      assert_enqueued(worker: SearchWorker)

      assert length(search_results) == 5
    end

    test "returns an error given invalid information" do
      report = build(:report)

      assert {:error, :invalid_params, changeset} =
               Reports.create_report("user_MISSING", report.title, report.csv_path)

      assert errors_on(changeset) == %{user_id: ["is invalid"]}

      refute_enqueued(worker: SearchWorker)

      assert Repo.all(SearchResult) == []
    end

    test "returns an error if one keyword fails to save and rolls back transaction" do
      %{id: user_id} = insert(:user)
      %{title: report_title, csv_path: report_csv_path} = build(:report)

      SearchResults
      |> expect(:create_search_result, fn word ->
        SearchResults.create_search_result(%{search_term: word})
      end)
      |> stub(:create_search_result, fn _ ->
        {:error, %Ecto.Changeset{valid?: false}}
      end)

      assert Reports.create_report(user_id, report_title, report_csv_path) ==
               {:error, :failed_to_save_keywords}

      refute_enqueued(worker: SearchWorker)

      assert Repo.all(SearchResult) == []
    end
  end

  describe "get_by/1" do
    test "returns {:ok, report} when given valid params" do
      user = insert(:user)
      _other_user = insert(:user)

      %{id: report_id} = insert(:report, user: user)
      _other_report = insert(:report)

      assert {:ok, %{id: ^report_id}} = Reports.get_by(%{id: report_id, user_id: user.id})
    end

    test "returns {:ok, report} with search result preloaded" do
      %{id: report_id} = report = insert(:report)
      %{id: search_result_id} = search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      assert {:ok, %{id: ^report_id, search_results: [%{id: ^search_result_id}]}} =
               Reports.get_by(%{id: report_id})
    end

    test "returns {:error, :not_found} when given invalid params" do
      assert Reports.get_by(%{id: 0}) == {:error, :not_found}
    end
  end

  describe "list_reports_by_user/1" do
    test "returns a list of reports given a valid user id" do
      user = insert(:user)
      other_user = insert(:user)

      %{id: report_id} = insert(:report, user: user)
      _report = insert(:report, user: other_user)

      assert [%{id: ^report_id}] = Reports.list_reports_by_user(user.id)
    end

    test "returns an empty list given user has no reports" do
      user = insert(:user)

      assert Reports.list_reports_by_user(user.id) == []
    end
  end

  describe "total_searched_report_keywords_count/1" do
    test "returns a count of keywords of all searched results" do
      report = insert(:report)

      search_term = insert(:only_search_term)

      insert(:report_search_result, report: report)
      insert(:report_search_result, report: report, search_result: search_term)
      insert(:report_search_result)

      assert Reports.total_searched_report_keywords_count(report.id) == 1
    end
  end

  describe "total_report_keywords_count/1" do
    test "returns a count of all keywords in report" do
      report = insert(:report)

      search_term = insert(:only_search_term)

      insert(:report_search_result, report: report)
      insert(:report_search_result, report: report, search_result: search_term)
      insert(:report_search_result)

      assert Reports.total_report_keywords_count(report.id) == 2
    end
  end

  describe "report_status/1" do
    test "returns `Searching` if some keywords does NOT have an HTML cache" do
      report = insert(:report)

      search_result = insert(:search_result, html_cache: nil)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      assert Reports.report_status(report) == "Searching"
    end

    test "returns `Completed` if all keywords have an HTML cache" do
      report = insert(:report)

      search_result = insert(:search_result, html_cache: "<html><body><p>HI</p></body></html>")

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      assert Reports.report_status(report) == "Completed"
    end
  end

  describe "total_top_advertisers_count/1" do
    test "returns number of top advertisers found in a report" do
      report = insert(:report)

      search_result = insert(:search_result, number_of_top_advertisers: 1)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      search_result2 = insert(:search_result, number_of_top_advertisers: 2)

      _report_search_result2 =
        insert(:report_search_result, report: report, search_result: search_result2)

      assert Reports.total_top_advertisers_count(report.id) == 3
    end
  end
end
