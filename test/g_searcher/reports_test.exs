defmodule GSearcher.ReportsTest do
  use GSearcher.DataCase

  alias GSearcher.{Reports, Search}
  alias GSearcher.Search.SearchResult

  describe "create_report/3" do
    test "returns report given a valid CSV and valid information" do
      user = insert(:user)
      report = build(:report)

      assert {:ok, report} = Reports.create_report(user.id, report.title, report.csv_path)

      search_results = Repo.all(SearchResult)

      assert length(search_results) == 5
    end

    test "returns an error given invalid information" do
      report = build(:report)

      assert {:error, :report, changeset} =
               Reports.create_report("user_MISSING", report.title, report.csv_path)

      assert errors_on(changeset) == %{user_id: ["is invalid"]}

      assert [] = Repo.all(SearchResult)
    end

    test "returns an error if one keyword fails to save" do
      user = insert(:user)
      report = build(:report)

      stub(Search, :create_search_result, fn _ -> {:error, %Ecto.Changeset{valid?: false}} end)

      assert {:error, :search_keywords, :failed_to_save_from_file} =
               Reports.create_report(user.id, report.title, report.csv_path)

      assert [] = Repo.all(SearchResult)
    end
  end
end
