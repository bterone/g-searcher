defmodule GSearcher.Validators.API.CreateReportParamsTest do
  use GSearcher.DataCase

  alias GSearcherWeb.Validators.API.CreateReportParams

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      params = %{
        "csv" => %Plug.Upload{
          path: "test/support/fixtures/test.csv",
          filename: "test.csv",
          content_type: "text/csv"
        }
      }

      changeset = CreateReportParams.changeset(params)

      assert changeset.valid? == true
    end

    test "returns invalid changeset given invalid params" do
      params = %{
        "csv" => %Plug.Upload{
          path: "/cat_picture.jpg",
          filename: "cat_picture.jpg",
          content_type: "image/jpeg"
        }
      }

      changeset = CreateReportParams.changeset(params)

      assert changeset.valid? == false

      assert errors_on(changeset) === %{csv: ["is not a CSV"]}
    end
  end
end
