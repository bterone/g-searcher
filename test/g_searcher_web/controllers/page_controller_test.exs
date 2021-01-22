defmodule GSearcherWeb.PageControllerTest do
  use GSearcherWeb.ConnCase

  describe "index/2" do
    test "renders home page when not signed in", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "No business can sell what is already made"
    end

    test "redirects to dashboard when signed in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> sign_in(user)
        |> get("/")

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end
  end
end
