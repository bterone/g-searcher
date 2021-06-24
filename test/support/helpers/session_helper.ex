defmodule GSearcher.Helpers.SessionHelper do
  import GSearcher.Factory

  alias GSearcher.Tokenizer
  alias Plug.Conn

  def assign_user_auth(%Conn{} = conn, user) do
    Conn.assign(conn, :ueberauth_auth, build_ueberauth_payload(user))
  end

  def authenticate_user(%Conn{} = conn, user) do
    {:ok, access_token, _} = Tokenizer.generate_access_token(user)

    Conn.put_req_header(conn, "authorization", "Bearer " <> access_token)
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
