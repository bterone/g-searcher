defmodule GSearcherWeb.NumberHelpers do
  @empty_value "-"

  def formatted_count(nil), do: @empty_value
  def formatted_count(count), do: Number.Delimit.number_to_delimited(count, precision: 0)

  def number_to_human(nil), do: @empty_value

  def number_to_human(number) do
    number
    |> Number.Human.number_to_human(precision: 2)
    |> remove_insignificant_numbers_from_string()
  end

  defp remove_insignificant_numbers_from_string(humanized_number) do
    Regex.replace(~r/(\.)(\d*[1-9])?0+\b/, humanized_number, "\\1\\2")
    |> remove_decimal_point_if_no_decimals()
  end

  defp remove_decimal_point_if_no_decimals(string) do
    Regex.replace(~r/(\.)( )/, string, "\\2")
  end
end
