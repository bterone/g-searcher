defmodule GSearcher.AccountsTest do
  use GSearcher.DataCase

  alias GSearcher.Accounts

  describe "users" do
    alias GSearcher.Accounts.User

    test "get_user!/1 returns the user with given id" do
      user = insert(:user, password: nil, password_confirmation: nil)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      user_params = params_for(:user, username: "Terone123")

      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.username == "Terone123"
      assert user.encrypted_password
    end

    test "create_user/1 with invalid data returns error changeset" do
      invalid_params = params_for(:user, password: nil, password_confirmation: nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_params)
    end

    test "change_user/1 returns a user changeset" do
      user = build(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
