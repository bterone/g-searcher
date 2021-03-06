defmodule GSearcher.SearchResults.SearchResultParserTest do
  use GSearcher.DataCase, async: true

  alias GSearcher.SearchResults.SearchResultParser

  describe "parse/1" do
    test "extracts search result when given valid HTML" do
      search_result_html = sample_html()

      assert {
               :ok,
               %{
                 number_of_results_on_page: 3,
                 number_of_top_advertisers: 2,
                 number_of_regular_advertisers: 1,
                 search_result_urls: [%{title: "SEARCH RESULT", url: _}, _, _],
                 top_advertiser_urls: [%{title: "TOP AD", url: _}, _],
                 regular_advertiser_urls: [%{title: "BOTTOM AD", url: "bot1.com"}],
                 total_number_of_results: 677_000_000,
                 html_cache: ^search_result_html
               }
             } = SearchResultParser.parse(search_result_html)
    end

    test "returns no results when given HTML without ads or results" do
      no_results = no_results_sample_html()

      assert {
               :ok,
               %{
                 number_of_results_on_page: 0,
                 number_of_top_advertisers: 0,
                 number_of_regular_advertisers: 0,
                 search_result_urls: [],
                 top_advertiser_urls: [],
                 regular_advertiser_urls: [],
                 total_number_of_results: 0,
                 html_cache: ^no_results
               }
             } = SearchResultParser.parse(no_results)
    end

    test "returns error with reason when given invalid HTML" do
      stub(Floki, :parse_document, fn _ -> {:error, "error"} end)

      assert SearchResultParser.parse("Invalid HTML") == {:error, :failed_to_parse_html, "error"}
    end
  end

  defp sample_html do
    """
    <html>
      <head></head>
      <body>
        <span id="result-stats">About 677,000,000 results (0.99 seconds)</span>
        <div id="tads">
          <a href="top1.com">
            <div role="heading">TOP AD</div>
          </a>
          <a href="top2.com">
            <div role="heading">TOP AD</div>
          </a>
          <a href="https://www.google.com/?clk">
            <div role="heading">Ignored link</div>
          </a>
        </div>
        <div id="search">
          <div class="g"><div><div>
            <a href="search1.com">
              <h3>SEARCH RESULT</h3>
            </a>
          </div></div></div>
          <div class="g"><div><div>
            <a href="search2.com">
              <h3>SEARCH RESULT</h3>
            </a>
          </div></div></div>
          <div class="g"><div><div>
            <a href="search3.com">
              <h3>SEARCH RESULT</h3>
            </a>
          </div></div></div>
        </div>
        <div id="bottomads">
          <div id="tadsb">
            <a href="bot1.com">
              <div role="heading">BOTTOM AD</div>
            </a>
          </div>
        </div>
      </body>
    </html>
    """
  end

  defp no_results_sample_html do
    """
    <html>
      <head></head>
      <body>
        <div> No results found </div>
      </body>
    </html>
    """
  end
end
