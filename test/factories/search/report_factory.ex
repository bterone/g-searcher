defmodule GSearcher.SearchResults.ReportFactory do
  alias GSearcher.SearchResults.Report

  defmacro __using__(_opts) do
    quote do
      def report_factory do
        %Report{
          title: sequence(:title, &"#{Faker.Lorem.word()}#{&1}"),
          user: build(:user),
          csv_path: "test/support/fixtures/test.csv"
        }
      end
    end
  end
end
