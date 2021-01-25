defmodule GSearcherWeb.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def render_error(conn, status) do
    conn
    |> put_status(status)
    |> put_layout(false)
    |> put_view(GSearcherWeb.ErrorView)
    |> render("#{status}_page.html")
    |> halt()
  end
end
