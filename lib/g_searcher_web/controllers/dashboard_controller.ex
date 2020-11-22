defmodule GSearcherWeb.DashboardController do
  use GSearcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
