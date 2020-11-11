defmodule GSearcher.Accounts.UserTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Accounts.User

  describe "changeset/2" do
    test "returns invalid changeset if required params are missing" do
      changeset = User.changeset(%{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               email: ["can't be blank"],
               provider: ["can't be blank"],
               token: ["can't be blank"]
             }
    end

    test "returns invalid if required params are empty" do
      changeset = User.changeset(%{email: "", provider: "", token: ""})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               email: ["can't be blank"],
               provider: ["can't be blank"],
               token: ["can't be blank"]
             }
    end
  end
end
