defmodule GSearcher.Search.ReportFactory do
  alias GSearcher.Search.Report

  defmacro __using__(_opts) do
    quote do
      def report_factory do
        %Report{
          title: Faker.Lorem.word(),
          user: insert(:user)
        }
      end
    end
  end
end
