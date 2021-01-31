defmodule GSearcherWeb.ReportView do
  use GSearcherWeb, :view

  @completed "Completed"
  @searching "Searching"
  @empty_value "-"

  def formatted_count(nil), do: @empty_value
  def formatted_count(count), do: count

  def status(%{html_cache: html}) when is_binary(html),
    do: @completed

  def status(_), do: @searching

  def modifer_class(term), do: String.downcase(term)
end
