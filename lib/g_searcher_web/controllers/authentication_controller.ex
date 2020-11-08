defmodule GSearcherWeb.AuthenticationController do
  use GSearcherWeb, :controller

  plug Ueberauth

  alias GSearcher.Accounts.User
  alias GSearcher.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

  def sign_out(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You successfully logged in!")
        |> put_session(:current_user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Sorry! Something went wrong!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
