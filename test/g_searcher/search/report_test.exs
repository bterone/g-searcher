defmodule GSearcher.Search.ReportTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Search.Report

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      report_params = params_for(:report)

      changeset = Report.changeset(report_params)

      assert changeset.valid?
    end

    test "returns invalid changeset if required params are missing" do
      changeset = Report.changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               title: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end

    test "returns invalid if required params are empty" do
      changeset = Report.changeset(%{title: "", user_id: ""})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               title: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end
end
