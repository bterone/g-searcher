defmodule GSearcherWeb.APICase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use GSearcherWeb.APICase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import GSearcherWeb.APICase
      import GSearcher.Factory
      import GSearcher.Helpers.SessionHelper

      import Mimic

      alias GSearcherWeb.APIRouter.Helpers, as: APIRoutes

      # The default endpoint for testing
      @endpoint GSearcherWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GSearcher.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GSearcher.Repo, {:shared, self()})
    end

    conn =
      :get
      |> Phoenix.ConnTest.build_conn("/api")
      |> Plug.Conn.put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
end
