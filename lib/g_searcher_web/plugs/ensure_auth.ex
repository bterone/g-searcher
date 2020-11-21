defmodule GSearcherWeb.Plugs.EnsureAuth do
  @moduledoc """
  Plug containing authentication checks to the user to guard access to routes
  """

  import Plug.Conn
  import Phoenix.Controller

  alias GSearcherWeb.Router.Helpers, as: Routes

  def init(_options), do: nil

  def call(conn, _options) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "You need to sign in or sign up before continuing.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
