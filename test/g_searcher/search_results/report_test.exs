defmodule GSearcher.SearchResults.ReportTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.SearchResults.Report

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      user = insert(:user)
      report_params = params_for(:report, user: user)

      changeset = Report.create_changeset(report_params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are missing" do
      changeset = Report.create_changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               title: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end

    test "returns invalid changeset if required params are empty" do
      changeset = Report.create_changeset(%{title: "", user_id: ""})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               title: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end
end
