defmodule GSearcher.SearchResults.ReportSearchResultFactory do
  alias GSearcher.SearchResults.ReportSearchResult

  defmacro __using__(_opts) do
    quote do
      def report_search_result_factory do
        %ReportSearchResult{
          report: build(:report),
          search_result: build(:search_result)
        }
      end
    end
  end
end
