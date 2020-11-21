defmodule GSearcherWeb.Plugs.SetCurrentUserTest do
  use GSearcherWeb.ConnCase, async: true
  import GSearcherWeb.Plugs.SetCurrentUser

  test "set the current user if user token is valid", %{conn: conn} do
    user = insert(:user, email: "john.doe@email.com")

    conn =
      conn
      |> sign_in(user)
      |> call(%{})

    assert conn.assigns.current_user.email == "john.doe@email.com"
    assert conn.assigns.user_signed_in? == true
  end

  test "set the current user to nil if the user token is invalid", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(%{})
      |> call(%{})

    assert conn.assigns.current_user == nil
    assert conn.assigns.user_signed_in? == false
  end
end
