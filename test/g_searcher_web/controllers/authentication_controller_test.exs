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
    end

    test "register user given valid params", %{conn: conn} do
      user_params = build(:user)

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :info) == "You successfully logged in!"

      assert [user_in_db] = Repo.all(User)
    end
  end
end
