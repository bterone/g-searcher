defmodule GSearcherWeb.Plugs.API.SetUser do
  import Plug.Conn

  alias GSearcher.Accounts.User
  alias GSearcherWeb.ErrorHandler

  def init(_options), do: nil

  def call(conn, _options) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user ->
        assign(conn, :user, user)

      _ ->
        ErrorHandler.render_error_json(conn, :unauthorized)
    end
  end
end
