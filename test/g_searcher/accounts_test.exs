defmodule GSearcher.AccountsTest do
  use GSearcher.DataCase

  alias GSearcher.Accounts

  describe "get_by_user_id!/1" do
    test "returns user if user exists" do
      user = insert(:user)
      assert Accounts.get_by_user_id!(user.id) == user
    end
  end
end
