defmodule GSearcherWeb.ReportControllerTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcher.Repo
  alias GSearcher.SearchResults.Report

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

    test "renders dashboard with error flash if report title is taken", %{conn: conn} do
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
      assert html_response(conn, 200) =~ "is already used"
    end

    test "redirects to dashboard with error flash if CSV is invalid", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> sign_in(user)
        |> post(
          Routes.report_path(conn, :create),
          %{
            "report" => %{
              "title" => "Test Report",
              "csv" => %Plug.Upload{
                path: "invalid_path",
                filename: "invalid_filename",
                content_type: "text/csv"
              }
            }
          }
        )

      assert get_flash(conn, :error) == "Failed to save from file."
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      assert [] = Repo.all(Report)
    end
  end

  describe "show/2" do
    test "renders report when given a valid report ID that belongs to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.report_path(conn, :show, report.id))

      assert html_response(conn, 200) =~ report.title
    end

    test "renders 404 page when given a report ID that does not belong to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.report_path(conn, :show, report.id))

      assert html_response(conn, 404) =~ "Page not found"
    end
  end
end
