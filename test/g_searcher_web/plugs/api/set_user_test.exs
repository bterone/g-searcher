defmodule GSearcherWeb.Plugs.API.SetUserTest do
  use GSearcherWeb.APICase, async: true

  alias GSearcher.Tokenizer
  alias GSearcherWeb.APIRouter
  alias GSearcherWeb.Plugs.API.SetUser

  test "user passes when token is valid", %{conn: conn} do
    user = insert(:user)
    {:ok, access_token, _} = Tokenizer.generate_access_token(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> access_token)
      |> bypass_through(APIRouter, [:api, :authentication])
      |> get(APIRoutes.api_authentication_path(conn, :callback, "test"))

    assert conn.halted == false
    assert conn.private.guardian_default_claims["sub"] == user.id
    assert conn.assigns.user == user
  end

  test "user is unauthorized when token is invalid", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "bearer:" <> "INVALID_TOKEN")
      |> SetUser.call(%{})

    assert conn.halted

    assert json_response(conn, 401) == %{
             "errors" => [
               %{
                 "detail" => "Unauthorized",
                 "status" => "unauthorized"
               }
             ]
           }
  end
end
