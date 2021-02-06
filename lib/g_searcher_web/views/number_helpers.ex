defmodule GSearcherWeb.NumberHelpers do
  @empty_value "-"

  def formatted_count(nil), do: @empty_value
  def formatted_count(count), do: Number.Delimit.number_to_delimited(count, precision: 0)

  def number_to_human(nil), do: @empty_value

  def number_to_human(number) when number < 1_000_000_000,
    do: Number.Human.number_to_human(number, precision: 0)

  def number_to_human(number), do: Number.Human.number_to_human(number, precision: 2)
end
