defmodule GSearcherWeb.SearchResultControllerTest do
  use GSearcherWeb.ConnCase

  describe "show/2" do
    test "renders search result given user is logged in and belongs to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :show, search_result.id))

      assert html_response(conn, 200)
    end

    test "renders 404 given search result does NOT belong to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :show, search_result.id))

      assert html_response(conn, 404)
    end
  end

  describe "result_snapshot/2" do
    test "renders search result HTML cache given search result belongs to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :result_snapshot, search_result.id))

      assert html_response(conn, 200)
    end

    test "renders 404 given search result does NOT belong to user", %{conn: conn} do
      user = insert(:user)
      report = insert(:report)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :result_snapshot, search_result.id))

      assert html_response(conn, 404)
    end
  end
end
