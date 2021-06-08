defmodule GSearcherWeb.Helpers.SearchHelperTest do
  use GSearcherWeb.ConnCase

  alias GSearcherWeb.Helpers.SearchHelper

  describe "parse_query/1" do
    test "returns a filter map given some filter params string" do
      query_1 = "Some String title:Example url:test.com"
      query_2 = "Some title:Example String"

      assert SearchHelper.parse_query(query_1) ==
               {:ok,
                %{
                  "query" => "Some String",
                  "title" => "Example",
                  "url" => "test.com"
                }}

      assert SearchHelper.parse_query(query_2) ==
               {:ok, %{"query" => "Some String", "title" => "Example"}}
    end

    test "returns the given query in a map given a regular string" do
      query_1 = "A regular string with some : and /"
      query_2 = "https://www.google.com/search?q=cats&oq=cats"

      assert SearchHelper.parse_query(query_1) == {:ok, %{"query" => query_1}}
      assert SearchHelper.parse_query(query_2) == {:ok, %{"query" => query_2}}
    end

    test "returns correct filter map given filter params with double quotes" do
      query = "Some String title:\"Title Example\" url:\"https://www.test.com/\""

      assert SearchHelper.parse_query(query) ==
               {:ok,
                %{
                  "query" => "Some String",
                  "title" => "Title Example",
                  "url" => "https://www.test.com/"
                }}
    end

    test "returns escaped percentage sign in query given a regular string" do
      query = "Some % string title:\"%tea\""

      assert SearchHelper.parse_query(query) ==
               {:ok,
                %{
                  "query" => "Some \\% string",
                  "title" => "\\%tea"
                }}
    end
  end
end
