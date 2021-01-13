defmodule GSearcher.SearchResults.SearchResultParserTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.SearchResults.SearchResultParser

  describe "parse/1" do
    test "extracts advertiser information given valid HTML" do
      assert {
               :ok,
               %{
                 number_of_results_on_page: 3,
                 number_of_top_advertisers: 2,
                 number_of_regular_advertisers: 1,
                 search_result_urls: [_, _, _],
                 top_advertiser_urls: [_, _],
                 regular_advertiser_urls: [_],
                 total_number_of_results: 677_000_000,
                 html_cache: sample_html
               }
             } = SearchResultParser.parse(sample_html)
    end
  end

  defp sample_html do
    """
    <html>
      <head></head>
      <body>
        <span id="result-stats">About 677,000,000 results (0.99 seconds)</span>
        <div id="tads">
          <a href="top1.com"></a>
          <a href="top2.com"></a>
        </div>
        <div id="search">
          <div class="g"><div><div><a href="search1.com"></a></div></div></div>
          <div class="g"><div><div><a href="search2.com"></a></div></div></div>
          <div class="g"><div><div><a href="search3.com"></a></div></div></div>
        </div>
        <div id="bottomads">
          <div id="tadsb">
            <a href="bot1.com"></a>
          </div>
        </div>
      </body>
    </html>
    """
  end
end
