defmodule GSearcher.Helpers.SessionHelper do
  alias Plug.Conn
  import GSearcher.Factory

  def assign_user_auth(%Conn{} = conn, user) do
    Conn.assign(conn, :ueberauth_auth, build_ueberauth_payload(user))
  end

  def sign_in(%Conn{} = conn, user) do
    Plug.Test.init_test_session(conn, current_user_id: user.id)
  end

  def sign_in(%Conn{} = conn) do
    user = insert(:user)
    Plug.Test.init_test_session(conn, current_user_id: user.id)
  end

  defp build_ueberauth_payload(%{
         token: token,
         email: email
       }) do
    %Ueberauth.Auth{
      credentials: %{
        token: token
      },
      provider: :google,
      info: %{
        email: email
      }
    }
  end
end
