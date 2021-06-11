defmodule GSearcherWeb.ReportView do
  use GSearcherWeb, :view

  def modifer_class(term), do: String.downcase(term)
end
