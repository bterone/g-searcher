defmodule GSearcherWeb.AuthenticationControllerTest do
  use GSearcherWeb.ConnCase

  alias GSearcher.Accounts
  alias GSearcher.Accounts.User
  alias GSearcher.Repo

  describe "get /:provider" do
    test "redirects to oauth page", %{conn: conn} do
      conn =
        conn
        |> get(Routes.authentication_path(conn, :request, "google"))

      assert redirected_to(conn, 302) =~ "google.com"
    end
  end

  describe "get /:provider/callback" do
    test "signs in user and redirects to homepage given a valid user", %{conn: conn} do
      user = insert(:user, provider: "google")

      conn =
        conn
        |> assign_user_auth(user)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :info) == "You successfully logged in!"
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end

    test "register user and redirects to homepage given valid params", %{conn: conn} do
      user_params = build(:user)

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :info) == "You successfully logged in!"
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      [user_in_db] = Repo.all(User)

      assert user_in_db.token == user_params.token
    end

    test "redirects to homepage with error if fail to save user", %{conn: conn} do
      user_params = build(:user)

      expect(Accounts, :create_user, fn _ -> {:error, %Ecto.Changeset{valid?: false}} end)

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(Routes.authentication_path(conn, :callback, "google"))

      assert get_flash(conn, :error) == "Sorry! Something went wrong!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      assert [] = Repo.all(User)
    end
  end

  describe "delete /sign-out" do
    test "redirects to homepage when session is deleted", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> delete(Routes.authentication_path(conn, :sign_out))

      assert get_flash(conn, :info) == "Signed out successfully!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end
end
