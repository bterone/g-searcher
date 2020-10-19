{:ok, _} = Application.ensure_all_started(:ex_machina)

{:ok, _} = Application.ensure_all_started(:mox)

{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(GSearcher.Repo, :manual)

Application.put_env(:wallaby, :base_url, GSearcherWeb.Endpoint.url())
