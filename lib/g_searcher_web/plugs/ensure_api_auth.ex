defmodule GSearcherWeb.Plugs.EnsureAPIAuth do
  import Plug.Conn

  alias GSearcher.Accounts.User
  alias GSearcherWeb.ErrorHandler

  def init(default), do: default

  def call(conn, _default) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user ->
        assign(conn, :user, user)

      _ ->
        ErrorHandler.render_error_json(conn, :unauthorized)
    end
  end
end
