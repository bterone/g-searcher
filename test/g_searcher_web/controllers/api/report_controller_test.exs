defmodule GSearcherWeb.API.ReportControllerTest do
  use GSearcherWeb.APICase, async: true

  alias GSearcher.Repo
  alias GSearcher.SearchResults.Report

  describe "create/2" do
    test "redirects to dashboard with success flash given valid CSV", %{conn: conn} do
      user = insert(:user)
      report = build(:report)

      conn =
        conn
        |> authenticate_user(user)
        |> post(
          APIRoutes.api_report_path(conn, :create),
          %{
            "csv" => %Plug.Upload{
              path: report.csv_path,
              filename: "test.csv",
              content_type: "text/csv"
            }
          }
        )

      assert conn.status == 204

      assert [report_in_db] = Repo.all(Report)
      assert report_in_db.title == "test.csv"
    end

    test "renders dashboard with error flash if report title is taken", %{conn: conn} do
      user = insert(:user)
      _old_report = insert(:report, user: user, title: "test.csv")

      conn =
        conn
        |> authenticate_user(user)
        |> post(
          APIRoutes.api_report_path(conn, :create),
          %{
            "csv" => %Plug.Upload{
              path: "test/support/fixtures/test.csv",
              filename: "test.csv",
              content_type: "text/csv"
            }
          }
        )

      assert json_response(conn, 400) == %{
               "errors" => [
                 %{
                   "detail" => "title is already used",
                   "status" => "bad_request"
                 }
               ]
             }
    end

    test "redirects to dashboard with error flash if CSV is invalid", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authenticate_user(user)
        |> post(
          APIRoutes.api_report_path(conn, :create),
          %{
            "csv" => %Plug.Upload{
              path: "invalid_path",
              filename: "invalid_filename",
              content_type: "text/csv"
            }
          }
        )

      assert json_response(conn, 500) == %{
               "errors" => [
                 %{
                   "detail" => "Failed to save from file",
                   "status" => "internal_server_error"
                 }
               ]
             }

      assert Repo.all(Report) == []
    end
  end
end
