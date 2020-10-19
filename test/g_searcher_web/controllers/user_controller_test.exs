defmodule GSearcherWeb.UserControllerTest do
  use GSearcherWeb.ConnCase

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to index when data is valid", %{conn: conn} do
      attrs = params_for(:user, password: "Password123", password_confirmation: "Password123")
      conn = post(conn, Routes.user_path(conn, :create), user: attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "User created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = params_for(:user, password: nil, password_confirmation: nil)

      conn = post(conn, Routes.user_path(conn, :create), user: attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end
end
