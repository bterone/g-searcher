defmodule GSearcherWeb.SearchResultView do
  use GSearcherWeb, :view

  def top_advertiser_urls(search_result_urls) do
    Enum.filter(search_result_urls, fn result_url -> result_url.is_top_ad end)
  end

  def other_advertiser_urls(search_result_urls) do
    Enum.filter(search_result_urls, fn result_url -> result_url.is_regular_ad end)
  end

  def non_ad_urls(search_result_urls) do
    Enum.filter(search_result_urls, fn result_url ->
      (result_url.is_top_ad || result_url.is_regular_ad) == false
    end)
  end
end
