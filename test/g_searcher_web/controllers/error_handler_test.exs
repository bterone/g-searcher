defmodule GSearcherWeb.ErrorHandlerTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.ErrorHandler

  defmodule CreateDeveloper do
    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field(:name, :string)
      field(:language, :string)
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name, :language])
      |> validate_required([:name, :language])
    end
  end

  describe "render_error/2" do
    test "renders 404 error page", %{conn: conn} do
      conn = ErrorHandler.render_error(conn, 404)

      assert html_response(conn, 404) =~ "Page not found"
      assert conn.halted
    end

    test "renders 500 error page", %{conn: conn} do
      conn = ErrorHandler.render_error(conn, 500)

      assert html_response(conn, 500) =~ "Something has gone wrong"
      assert conn.halted
    end
  end

  describe "build_changeset_error_message/1" do
    test "returns errors given an invalid changeset" do
      changeset = CreateDeveloper.changeset(%{name: "", language: ""})

      assert ErrorHandler.build_changeset_error_message(changeset) =~ "language can't be blank"
      assert ErrorHandler.build_changeset_error_message(changeset) =~ "name can't be blank"
    end
  end
end
