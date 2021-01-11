defmodule GSearcher.SearchResults.SearchResultFactory do
  alias GSearcher.SearchResults.SearchResult

  defmacro __using__(_opts) do
    quote do
      def only_search_term_factory do
        %SearchResult{
          search_term: Faker.Lorem.word()
        }
      end

      def search_result_factory do
        %SearchResult{
          search_term: Faker.Lorem.word(),
          total_number_results: :rand.uniform(1_000_000),
          number_of_results_on_page: :rand.uniform(20),
          all_urls: [Faker.Internet.domain_name()],
          html_cache: "<html><head></head><body>TEST</body></html>",
          number_of_top_advertisers: :rand.uniform(10),
          top_advertiser_urls: [Faker.Internet.domain_name()],
          total_number_of_advertisers: :rand.uniform(20),
          advertiser_urls: [Faker.Internet.domain_name()]
        }
      end
    end
  end
end
