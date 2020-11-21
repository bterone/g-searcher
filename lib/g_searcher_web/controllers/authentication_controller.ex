defmodule GSearcherWeb.AuthenticationController do
  use GSearcherWeb, :controller

  plug Ueberauth

  alias GSearcher.Accounts

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}

    sign_in(conn, user_params)
  end

  def sign_out(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp sign_in(conn, user_params) do
    case insert_or_update_user(user_params) do
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

  defp insert_or_update_user(user_params) do
    case Accounts.get_user_by_email(user_params.email) do
      nil ->
        Accounts.create_user(user_params)

      user ->
        {:ok, user}
    end
  end
end
