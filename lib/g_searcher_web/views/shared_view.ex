defmodule GSearcherWeb.SharedView do
  use GSearcherWeb, :view

  @completed "Completed"
  @searching "Searching"

  def status(%{html_cache: html}) when not is_nil(html),
    do: @completed

  def status(_), do: @searching
end
