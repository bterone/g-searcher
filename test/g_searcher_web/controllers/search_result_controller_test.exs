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
      assert conn.resp_body =~ search_result.search_term
    end

    test "renders search results belonging to user given invalid params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result, search_term: "Boba Tea")

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :index), %{query: "Tea top_ads:\"Boba Tea\""})

      assert html_response(conn, 200)
      assert get_flash(conn, :error) == "top_ads operation should only be '<, >, ='"
      assert conn.resp_body =~ search_result.search_term
    end

    test "renders search results belonging to user given no params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> sign_in(user)
        |> get(Routes.search_result_path(conn, :index))

      assert html_response(conn, 200)
      assert conn.resp_body =~ search_result.search_term
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
