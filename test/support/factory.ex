defmodule GSearcher.Factory do
  use ExMachina.Ecto, repo: GSearcher.Repo

  use GSearcher.Accounts.UserFactory
end
