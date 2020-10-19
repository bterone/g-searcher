defmodule GSearcher.Accounts.UserTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Repo
  alias GSearcher.Accounts.User

  describe "changeset/2" do
    test "username is unique" do
      insert(:user, username: "Terone123")
      duplicated_user = User.changeset(%User{}, params_for(:user, username: "Terone123"))

      assert {:error, changeset} = Repo.insert(duplicated_user)

      refute changeset.valid?
      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end

    test "requires username, password and password confirmation" do
      changeset = User.changeset(%User{}, %{})

      refute changeset.valid?
      assert %{username: ["can't be blank"]} = errors_on(changeset)
      assert %{password: ["can't be blank"]} = errors_on(changeset)
      assert %{password_confirmation: ["can't be blank"]} = errors_on(changeset)
    end

    test "password has at least 6 characters" do
      attributes = params_for(:user, password: "A", password_confirmation: "A")
      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end

    test "password is encrypted" do
      attributes =
        params_for(:user,
          password: "StrongPassword123",
          password_confirmation: "StrongPassword123"
        )

      changeset = User.changeset(%User{}, attributes)

      assert changeset.valid?
      assert get_change(changeset, :encrypted_password) != "StrongPassword123"
      assert get_change(changeset, :encrypted_password)
    end
  end
end
