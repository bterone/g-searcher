defmodule GSearcher.TokenizerTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.Tokenizer

  describe "generate_access_token/1" do
    test "generates a valid access token given a user" do
      user = insert(:user)

      {:ok, access_token, _} = Tokenizer.generate_access_token(user)

      assert {:ok, claims} = Tokenizer.decode_and_verify(access_token)
      assert claims["sub"] == user.id
      assert claims["typ"] == "access"
    end
  end

  describe "subject_for_token/2" do
    test "returns resource ID from a given resource" do
      user = insert(:user)

      assert Tokenizer.subject_for_token(user, %{}) == {:ok, user.id}
    end
  end

  describe "resource_from_claims/1" do
    test "returns {:ok, user} when user is found from claims" do
      user = insert(:user)
      claims = %{"sub" => user.id}

      assert Tokenizer.resource_from_claims(claims) == {:ok, user}
    end

    test "returns {:error, :not_found} when the user is NOT found from claims" do
      claims = %{"sub" => 0}

      assert Tokenizer.resource_from_claims(claims) == {:error, :not_found}
    end
  end
end
