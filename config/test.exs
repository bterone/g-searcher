use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :g_searcher, GSearcher.Repo,
  username: "postgres",
  password: "postgres",
  database: "g_searcher_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :g_searcher, GSearcherWeb.Endpoint,
  http: [port: 4002],
  server: true

config :g_searcher, :sql_sandbox, true
config :g_searcher, Oban, crontab: false, queues: false, plugins: false

config :wallaby,
  otp_app: :g_searcher,
  chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
  screenshot_dir: "tmp/wallaby_screenshots",
  screenshot_on_failure: true

# Print only warnings and errors during test
config :logger, level: :warn
