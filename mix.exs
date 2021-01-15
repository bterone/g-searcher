defmodule GSearcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :g_searcher,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        lint: :test,
        coverage: :test,
        coveralls: :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GSearcher.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth, :ueberauth_google]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:wallaby, "~> 0.26.2", [only: :test, runtime: false]},
      {:sobelow, "~> 0.10.4", [only: [:dev, :test], runtime: false]},
      {:mox, "~> 1.0.0", [only: :test]},
      {:mimic, "~> 1.3", only: :test},
      {:ex_machina, "~> 2.4.0", [only: :test]},
      {:faker, "~> 0.15.0", [only: :test]},
      {:excoveralls, "~> 0.13.2", [only: :test]},
      {:dialyxir, "~> 1.0.0", [only: [:dev], runtime: false]},
      {:credo, "~> 1.5.0-rc.4", [only: [:dev, :test], runtime: false]},
      {:phoenix, "~> 1.5.5"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.3 or ~> 0.2.9"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:nimble_csv, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ueberauth, "~> 0.6.3"},
      {:ueberauth_google, "~> 0.10.0"},
      {:oban, "~> 2.3"},
      {:httpoison, "~> 1.7"},
      {:floki, "~> 0.29.0"},
      {:exvcr, "~> 0.12.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "assets.compile": &compile_assets/1,
      coverage: ["coveralls.html --raise"],
      codebase: ["format --check-formatted", "credo", "sobelow --config"],
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
  end
end
