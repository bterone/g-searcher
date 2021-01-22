defmodule GSearcherWeb.PageController do
  use GSearcherWeb, :controller

  def index(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      conn
      |> put_layout({GSearcherWeb.LayoutView, :landing})
      |> render("index.html")
    end
  end
end
