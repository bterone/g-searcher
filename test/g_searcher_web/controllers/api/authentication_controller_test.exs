defmodule GSearcherWeb.API.AuthenticationControllerTest do
  use GSearcherWeb.APICase, async: true

  alias GSearcher.Accounts
  alias GSearcher.Accounts.User
  alias GSearcher.{Repo, Tokenizer}

  describe "get /:provider" do
    test "redirects to oauth page", %{conn: conn} do
      conn =
        conn
        |> get(APIRoutes.api_authentication_path(conn, :request, "google"))

      assert redirected_to(conn, 302) =~ "google.com"
    end
  end

  describe "get /:proivder/callback" do
    test "returns access token when token is valid and found user with given email", %{conn: conn} do
      user = insert(:user, provider: "google")

      conn =
        conn
        |> assign_user_auth(user)
        |> get(APIRoutes.api_authentication_path(conn, :callback, "google"))

      assert %{
               "object" => "token",
               "access_token" => access_token
             } = json_response(conn, 200)

      {:ok, claims} = Tokenizer.decode_and_verify(access_token)

      assert user.id == claims["sub"]
    end

    test "registers user when token is valid and user does NOT exist", %{conn: conn} do
      user_params = params_for(:user, token: "USER_TOKEN")

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(APIRoutes.api_authentication_path(conn, :callback, "google"))

      assert %{
               "object" => "token",
               "access_token" => access_token
             } = json_response(conn, 200)

      {:ok, claims} = Tokenizer.decode_and_verify(access_token)

      user_in_db = Repo.get(User, claims["sub"])

      assert user_in_db.email == user_params.email
      assert user_in_db.token == "USER_TOKEN"
      assert user_in_db.provider == "google"
    end

    test "renders error if failed to save user", %{conn: conn} do
      user_params = build(:user)

      expect(Accounts, :create_user, fn _ -> {:error, %Ecto.Changeset{valid?: false}} end)

      conn =
        conn
        |> assign_user_auth(user_params)
        |> get(APIRoutes.api_authentication_path(conn, :callback, "google"))

      assert json_response(conn, 400) == %{
               "errors" => [
                 %{
                   "status" => "bad_request",
                   "detail" => "Unable to sign in"
                 }
               ]
             }
    end
  end
end
