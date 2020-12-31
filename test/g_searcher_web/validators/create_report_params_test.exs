defmodule GSearcher.Validators.CreateReportParamsTest do
  use GSearcher.DataCase

  alias GSearcherWeb.Validators.CreateReportParams

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      report = build(:report)

      params = %{
        "title" => "Test Report",
        "csv" => %Plug.Upload{
          path: report.csv_path,
          filename: "test.csv",
          content_type: "text/csv"
        }
      }

      changeset = CreateReportParams.changeset(params)

      assert changeset.valid? === true
    end

    test "returns invalid chanegset given invalid params" do
      params = %{
        "title" => "",
        "csv" => %Plug.Upload{
          path: "/cat_picture.jpg",
          filename: "cat_picture.jpg",
          content_type: "image/jpeg"
        }
      }

      changeset = CreateReportParams.changeset(params)

      assert changeset.valid? === false

      assert errors_on(changeset) === %{
               title: ["can't be blank"],
               csv: ["is not a CSV"]
             }
    end
  end
end
