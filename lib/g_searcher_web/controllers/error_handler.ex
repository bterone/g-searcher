defmodule GSearcherWeb.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  alias Ecto.Changeset
  alias GSearcherWeb.ErrorView

  def render_error(conn, status) do
    conn
    |> put_status(status)
    |> put_layout(false)
    |> put_view(ErrorView)
    |> render("#{status}_page.html")
    |> halt()
  end

  def render_error_json(conn, status),
    do: render_error_json(conn, status, Phoenix.Naming.humanize(status))

  def render_error_json(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", %{status: status, message: message})
    |> halt()
  end

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("error.json", %{status: :unauthorized, message: type})
  end

  def build_changeset_error_message(changeset) do
    errors =
      Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    error_message =
      errors
      |> Enum.map(fn {key, errors} -> "#{key} #{Enum.join(errors, ", ")}" end)
      |> Enum.join("\n")

    error_message
  end
end
