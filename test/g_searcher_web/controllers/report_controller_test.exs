defmodule GSearcherWeb.ReportControllerTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcher.Repo
  alias GSearcher.Search.Report

  describe "create/2" do
    test "redirects to dashboard with success flash given valid CSV", %{conn: conn} do
      user = insert(:user)
      report = build(:report)

      conn =
        conn
        |> sign_in(user)
        |> post(
          Routes.report_path(conn, :create),
          %{
            "report" => %{
              "title" => "Test Report",
              "csv" => %Plug.Upload{
                path: report.csv_path,
                filename: "test.csv",
                content_type: "text/csv"
              }
            }
          }
        )

      assert get_flash(conn, :info) == "Report generated successfully."
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      assert [report_in_db] = Repo.all(Report)
      assert report_in_db.title == "Test Report"
    end

    test "redirects to dashboard with error flash if report title is taken", %{conn: conn} do
      user = insert(:user)
      _old_report = insert(:report, user: user, title: "Taken Title")

      report = build(:report, title: "Taken Title")

      conn =
        conn
        |> sign_in(user)
        |> post(
          Routes.report_path(conn, :create),
          %{
            "report" => %{
              "title" => "Taken Title",
              "csv" => %Plug.Upload{
                path: report.csv_path,
                filename: "test.csv",
                content_type: "text/csv"
              }
            }
          }
        )

      assert get_flash(conn, :error) == "Something went wrong."
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end
  end
end
