defmodule GSearcherWeb.NumberHelpersTest do
  use GSearcher.DataCase, async: true

  alias GSearcherWeb.NumberHelpers

  describe "formatted_count/1" do
    test "returns delimited number given a value" do
      assert NumberHelpers.formatted_count(1_234_567_890) == "1,234,567,890"
    end

    test "returns '-' given nil" do
      assert NumberHelpers.formatted_count(nil) == "-"
    end
  end

  describe "number_to_human/1" do
    test "returns human readable number" do
      assert NumberHelpers.number_to_human(1_000_000) == "1 Million"
      assert NumberHelpers.number_to_human(1_750_000) == "1.75 Million"
      assert NumberHelpers.number_to_human(1_990_000) == "1.99 Million"
      assert NumberHelpers.number_to_human(1_999_000) == "2 Million"
      assert NumberHelpers.number_to_human(1_000_000_000) == "1 Billion"
      assert NumberHelpers.number_to_human(2_500_000_000) == "2.5 Billion"
    end

    test "returns '-' given nil" do
      assert NumberHelpers.number_to_human(nil) == "-"
    end
  end
end
