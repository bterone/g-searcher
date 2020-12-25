defmodule GSearcher.Validators.ReportParamValidatorTest do
  use GSearcher.DataCase

  alias GSearcher.Validators.ReportParamValidator

  describe "validate/2" do
    test "returns {:ok, valid_params} given valid params" do
      report = build(:report)

      params = %{
        "title" => "Test Report",
        "csv" => %Plug.Upload{
          path: report.csv_path,
          filename: "test.csv",
          content_type: "text/csv"
        }
      }

      assert {:ok, %{csv: _, title: "Test Report"}} = ReportParamValidator.validate(params)
    end

    test "returns {:error, :invalid_params, changeset} given invalid params" do
      params = %{
        "title" => "An Accident",
        "csv" => %Plug.Upload{
          path: "invalid_path",
          filename: "cat_picture.jpg",
          content_type: "text/plain"
        }
      }

      assert {:error, :invalid_params, changeset} = ReportParamValidator.validate(params)

      assert errors_on(changeset) == %{
               csv: ["is not a CSV"]
             }
    end
  end
end
