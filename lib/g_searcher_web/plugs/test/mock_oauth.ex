defmodule GSearcherWeb.Plugs.Tests.MockOauth do
  import Plug.Conn

  def init(_), do: nil

  def call(conn, _default) do
    conn = Plug.Conn.fetch_query_params(conn)
    email = Map.get(conn.query_params, "sign_in_as")

    assign(conn, :ueberauth_auth, build_auth_payload(email))
  end

  defp build_auth_payload(email) do
    %{
      credentials: %{
        token: "MOCK_TOKEN"
      },
      info: %{
        email: email
      }
    }
  end
end
