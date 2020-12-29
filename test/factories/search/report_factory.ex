defmodule GSearcher.SearchResults.ReportFactory do
  alias GSearcher.SearchResults.Report

  defmacro __using__(_opts) do
    quote do
      def report_factory do
        %Report{
          title: Faker.Lorem.word(),
          user: insert(:user),
          csv_path: "test/support/fixtures/test.csv"
        }
      end
    end
  end
end
