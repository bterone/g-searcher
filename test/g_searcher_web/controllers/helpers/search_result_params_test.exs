defmodule GSearcherWeb.Helpers.SearchResultParamsTest do
  use GSearcher.DataCase, async: true

  alias GSearcherWeb.Helpers.SearchResultParams

  describe "changeset/2" do
    test "returns valid changeset given valid params" do
      params = %{
        "query" => "Sample String",
        "title" => "A Title",
        "url" => "https://www.test.com"
      }

      changeset = SearchResultParams.changeset(params)

      assert changeset.valid?
      assert changeset.changes.search_term == "Sample String"
      assert changeset.changes.title == "A Title"
      assert changeset.changes.url == "https://www.test.com"
    end

    test "returns invalid changeset given blank query params" do
      changeset = SearchResultParams.changeset(%{"query" => ""})

      assert changeset.valid? == false

      assert errors_on(changeset) == %{
               search_term: ["can't be blank"]
             }
    end

    test "returns valid changeset given valid quantity operator and value for top and regular ads" do
      valid_params_1 = %{"query" => "Something", "top_ads" => ">10", "regular_ads" => "<10"}
      valid_params_2 = %{"query" => "Something else", "top_ads" => "=2", "regular_ads" => "=4"}

      valid_changeset_1 = SearchResultParams.changeset(valid_params_1)
      valid_changeset_2 = SearchResultParams.changeset(valid_params_2)

      assert valid_changeset_1.valid?
      assert valid_changeset_2.valid?
    end

    test "returns invalid changeset given invalid quantity operator for top or regular ads" do
      invalid_params_1 = %{"query" => "Something", "top_ads" => "N10"}
      invalid_params_2 = %{"query" => "Something", "regular_ads" => "Y99"}

      invalid_changeset_1 = SearchResultParams.changeset(invalid_params_1)
      invalid_changeset_2 = SearchResultParams.changeset(invalid_params_2)

      assert invalid_changeset_1.valid? == false
      assert invalid_changeset_2.valid? == false

      assert errors_on(invalid_changeset_1) == %{
               top_ads: ["operation should only be '<, >, ='"]
             }

      assert errors_on(invalid_changeset_2) == %{
               regular_ads: ["operation should only be '<, >, ='"]
             }
    end

    test "returns invalid changeset given invalid value for top or regular ads" do
      invalid_params_1 = %{
        "query" => "Something",
        "top_ads" => "='); DROP TABLE SearchResults;--"
      }

      invalid_params_2 = %{"query" => "Something", "regular_ads" => ">Ninety-nine"}

      invalid_changeset_1 = SearchResultParams.changeset(invalid_params_1)
      invalid_changeset_2 = SearchResultParams.changeset(invalid_params_2)

      assert invalid_changeset_1.valid? == false
      assert invalid_changeset_2.valid? == false

      assert errors_on(invalid_changeset_1) == %{
               top_ads: ["operation should use a number"]
             }

      assert errors_on(invalid_changeset_2) == %{
               regular_ads: ["operation should use a number"]
             }
    end
  end
end
