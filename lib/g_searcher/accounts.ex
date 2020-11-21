defmodule GSearcher.Accounts do
  alias GSearcher.Accounts.User
  alias GSearcher.Repo

  def get_user_by_id(user_id), do: Repo.get_by(User, id: user_id)
  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def create_user(params) do
    User.changeset(%User{}, params)
    |> Repo.insert()
  end
end
