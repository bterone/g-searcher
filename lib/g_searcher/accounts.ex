defmodule GSearcher.Accounts do
  import Ecto.Query, warn: false

  alias GSearcher.Accounts.User
  alias GSearcher.Repo

  def get_by_user_id!(user_id) do
    Repo.get_by(User, id: user_id)
  end
end
