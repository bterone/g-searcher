defmodule GSearcherWeb.AuthenticationControllerTest do
  use GSearcherWeb.ConnCase

  alias GSearcher.Accounts.User
  alias GSearcher.Repo

  describe "get /:provider/callback" do
    test "signs in user given a valid user", %{conn: conn} do
      user = insert(:user, provider: "google")

      conn =
        conn
        |> assign_user_auth(user)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :info) == "You successfully logged in!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "register user given valid params", %{conn: conn} do
      user_params = build(:user)

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :info) == "You successfully logged in!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      [user_in_db] = Repo.all(User)

      assert user_in_db.token == user_params.token
    end
  end
end
