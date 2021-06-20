defmodule GSearcher.Tokenizer do
  use Guardian, otp_app: :g_searcher

  alias GSearcher.Accounts

  def generate_access_token(user) do
    encode_and_sign(user, %{}, ttl: {1, :days}, token_type: "access")
  end

  def subject_for_token(resource, _options) do
    {:ok, resource.id}
  end

  def resource_from_claims(claims) do
    Accounts.get_user_by_id(claims["sub"])
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
