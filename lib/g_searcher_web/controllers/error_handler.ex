defmodule GSearcherWeb.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  alias Ecto.Changeset

  def render_error(conn, status) do
    conn
    |> put_status(status)
    |> put_layout(false)
    |> put_view(GSearcherWeb.ErrorView)
    |> render("#{status}_page.html")
    |> halt()
  end

  def combine_changeset_errors(changeset) do
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
