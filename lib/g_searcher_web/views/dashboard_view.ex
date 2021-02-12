defmodule GSearcherWeb.DashboardView do
  use GSearcherWeb, :view

  alias GSearcher.Reports

  @parsing "Parsing"
  @completed "Completed"

  def report_status(report) do
    total_keywords = Reports.total_report_keywords_count(report.id)
    total_searched_keywords = Reports.total_searched_report_keywords_count(report.id)

    cond do
      total_searched_keywords < total_keywords -> @parsing
      total_searched_keywords == total_keywords -> @completed
    end
  end
end
