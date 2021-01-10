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

      assert_enqueued worker: SearchWorker

      assert length(search_results) == 5
    end

    test "returns an error given invalid information" do
      report = build(:report)

      assert {:error, :invalid_params, changeset} =
               Reports.create_report("user_MISSING", report.title, report.csv_path)

      assert errors_on(changeset) == %{user_id: ["is invalid"]}

      refute_enqueued worker: SearchWorker

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

      refute_enqueued worker: SearchWorker

      assert Repo.all(SearchResult) == []
    end
  end
end
