defmodule GSearcher.Factory do
  use ExMachina.Ecto, repo: GSearcher.Repo

  # Define your factories
  # def user_factory do
  #   %User{
  #     email: sequence(:email, &"test-#{&1}@example.com")
  #   }
  # end
end
