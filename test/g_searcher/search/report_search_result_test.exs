defmodule GSearcher.Search.ReportSearchResultTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Repo
  alias GSearcher.Search.ReportSearchResult

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      report = insert(:report)
      search_result = insert(:search_result)

      changeset =
        ReportSearchResult.changeset(%{report_id: report.id, search_result_id: search_result.id})

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are empty" do
      changeset = ReportSearchResult.changeset(%{report_id: "", search_result_id: ""})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               report_id: ["can't be blank"],
               search_result_id: ["can't be blank"]
             }
    end

    test "returns invalid changeset when report association is invalid" do
      report = insert(:report)
      search_result = insert(:search_result)

      attrs = %{
        report_id: report.id,
        search_result_id: search_result.id
      }

      Repo.delete(report)

      {:error, changeset} = ReportSearchResult.changeset(attrs) |> Repo.insert()

      refute changeset.valid?

      assert errors_on(changeset) == %{
               report: ["does not exist"]
             }
    end
  end
end
