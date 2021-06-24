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

  describe "render_error_json/2" do
    test "renders error json given an error", %{conn: conn} do
      conn = ErrorHandler.render_error_json(conn, :not_found)

      assert json_response(conn, 404) == %{
               "errors" => [
                 %{
                   "detail" => "Not found",
                   "status" => "not_found"
                 }
               ]
             }
    end

    test "renders error json given an error and message", %{conn: conn} do
      conn = ErrorHandler.render_error_json(conn, :not_found, "Could not find record")

      assert json_response(conn, 404) == %{
               "errors" => [
                 %{
                   "detail" => "Could not find record",
                   "status" => "not_found"
                 }
               ]
             }
    end
  end

  describe "auth_error/3" do
    test "renders an auth error given an error tuple", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:invalid_token, nil}, nil)

      assert json_response(conn, 401) == %{
               "errors" => [
                 %{
                   "detail" => "invalid_token",
                   "status" => "unauthorized"
                 }
               ]
             }
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
