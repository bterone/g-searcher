defmodule GSearcherWeb.SearchResultViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.SearchResultView

  describe "top_advertiser_urls/1" do
    test "returns only top ad urls given search_result_urls" do
      search_result = insert(:search_result)
      top_ad = insert(:search_result_url, search_result: search_result, is_top_ad: true)

      regular_ad = insert(:search_result_url, search_result: search_result, is_regular_ad: true)
      non_ad = insert(:search_result_url, search_result: search_result)

      assert SearchResultView.top_advertiser_urls([top_ad, regular_ad, non_ad]) == [top_ad]
    end
  end

  describe "other_advertiser_urls/1" do
    test "returns only regular ad urls given search_result_urls" do
      search_result = insert(:search_result)
      regular_ad = insert(:search_result_url, search_result: search_result, is_regular_ad: true)

      top_ad = insert(:search_result_url, search_result: search_result, is_top_ad: true)
      non_ad = insert(:search_result_url, search_result: search_result)

      assert SearchResultView.other_advertiser_urls([top_ad, regular_ad, non_ad]) == [regular_ad]
    end
  end

  describe "non_ad_urls/1" do
    test "returns non advert URLs given search_result_urls" do
      search_result = insert(:search_result)
      non_ad = insert(:search_result_url, search_result: search_result)

      top_ad = insert(:search_result_url, search_result: search_result, is_top_ad: true)
      regular_ad = insert(:search_result_url, search_result: search_result, is_regular_ad: true)

      assert SearchResultView.non_ad_urls([top_ad, regular_ad, non_ad]) == [non_ad]
    end
  end
end
