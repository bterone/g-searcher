defmodule GSearcherWeb.DashboardControllerTest do
  use GSearcherWeb.ConnCase

  describe "index/2" do
    test "renders dashboard given user is logged in", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get(Routes.dashboard_path(conn, :index))

      assert html_response(conn, 200)
    end

    test "redirects to homepage with error given user is NOT logged in", %{conn: conn} do
      conn = get(conn, Routes.dashboard_path(conn, :index))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :error) == "You need to sign in or sign up before continuing."
    end
  end
end
