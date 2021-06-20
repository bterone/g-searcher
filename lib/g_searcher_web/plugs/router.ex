defmodule GSearcherWeb.Plugs.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  match("/api/*_", to: GSearcherWeb.APIRouter)
  match(_, to: GSearcherWeb.Router)
end
