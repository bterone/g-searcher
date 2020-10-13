defmodule GSearcher.Repo do
  use Ecto.Repo,
    otp_app: :g_searcher,
    adapter: Ecto.Adapters.Postgres
end
