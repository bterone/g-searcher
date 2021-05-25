defmodule GSearcherWeb.SearchResultControllerTest do
  use GSearcherWeb.ConnCase

  describe "index/2" do
    test "renders search results belonging to user given valid params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :index), query: "Example")

      assert html_response(conn, 200)
    end
  end

  describe "show/2" do
    test "renders search result given search result belongs to user", %{conn: conn} do
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
