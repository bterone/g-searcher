defmodule GSearcher.AccountsTest do
  use GSearcher.DataCase

  alias GSearcher.Accounts
  alias GSearcher.Accounts.User

  describe "get_user_by_id/1" do
    test "returns user if user exists" do
      user = insert(:user)
      assert Accounts.get_user_by_id(user.id) == user
    end
  end

  describe "get_user_by_email/1" do
    test "returns user if user exists" do
      user = insert(:user)
      assert Accounts.get_user_by_email(user.email) == user
    end
  end

  describe "create_user/1" do
    test "creates user given valid params" do
      user_params = params_for(:user)

      assert {:ok, user} = Accounts.create_user(user_params)
      assert [user_in_db] = Repo.all(User)
      assert user_in_db == user
    end

    test "does NOT create user given invalid params" do
      invalid_params = %{email: "", token: "", provider: ""}

      assert {:error, _} = Accounts.create_user(invalid_params)
      assert [] == Repo.all(User)
    end
  end
end
