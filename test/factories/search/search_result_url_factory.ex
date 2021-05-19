defmodule GSearcher.SearchResults.SearchResultURLFactory do
  alias GSearcher.SearchResults.SearchResultURL

  defmacro __using__(_opts) do
    quote do
      def search_result_url_factory do
        %SearchResultURL{
          title: Faker.Lorem.sentence(),
          url: Faker.Internet.domain_name(),
          is_top_ad: false,
          is_regular_ad: false
        }
      end
    end
  end
end
