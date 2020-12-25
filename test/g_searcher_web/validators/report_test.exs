defmodule GSearcher.Validators.ReportTest do
  use GSearcher.DataCase

  alias GSearcherWeb.Validators.Report, as: ReportParams
  alias GSearcherWeb.Validators.ParamValidator

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

      assert {:ok, %{csv: _, title: "Test Report"}} =
               ParamValidator.validate(params, for: ReportParams)
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

      assert {:error, :invalid_params, changeset} =
               ParamValidator.validate(params, for: ReportParams)

      assert errors_on(changeset) == %{
               csv: ["is not a CSV"]
             }
    end
  end
end
