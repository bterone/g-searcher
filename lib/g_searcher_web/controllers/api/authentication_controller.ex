defmodule GSearcherWeb.API.AuthenticationController do
  use GSearcherWeb, :controller

  plug Ueberauth

  alias GSearcher.{Accounts, Tokenizer}
  alias GSearcherWeb.ErrorHandler

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}

    sign_in(conn, user_params)
  end

  defp sign_in(conn, user_params) do
    case insert_or_update_user(user_params) do
      {:ok, user} ->
        {:ok, access_token, _} = Tokenizer.generate_access_token(user)

        conn
        |> put_status(:ok)
        |> render("token.json", %{access_token: access_token})

      {:error, _reason} ->
        ErrorHandler.render_error_json(conn, :bad_request, "Unable to sign in")
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
