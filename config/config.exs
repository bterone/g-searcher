# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :g_searcher,
  ecto_repos: [GSearcher.Repo]

# Configures the endpoint
config :g_searcher, GSearcherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "niqtfJG9iNjaTqK7B4dyrzoU+0an9E3JdUrB2YqFkEPMUfxKNL2JYnX3LJLyvBCK",
  render_errors: [view: GSearcherWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GSearcher.PubSub,
  live_view: [signing_salt: "WiEvKDKO"]

config :g_searcher, Oban,
  repo: GSearcher.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 5, events: 5]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
