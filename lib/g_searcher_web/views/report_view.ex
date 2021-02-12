defmodule GSearcherWeb.ReportView do
  use GSearcherWeb, :view

  @completed "Completed"
  @searching "Searching"

  def status(%{html_cache: html}) when not is_nil(html),
    do: @completed

  def status(_), do: @searching

  def modifer_class(term), do: String.downcase(term)
end
