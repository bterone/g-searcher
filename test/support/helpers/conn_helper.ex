defmodule GSearcher.Helpers.ConnHelper do
  alias Plug.Conn

  def assign_user_auth(conn, user) do
    Conn.assign(conn, :ueberauth_auth, build_ueberauth_payload(user))
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
