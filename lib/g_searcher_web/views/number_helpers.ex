defmodule GSearcherWeb.NumberHelpers do
  @empty_value "-"

  def formatted_count(nil), do: @empty_value
  def formatted_count(count), do: Number.Delimit.number_to_delimited(count, precision: 0)

  def number_to_human(nil), do: @empty_value

  def number_to_human(number) do
    number
    |> Number.Human.number_to_human(precision: 2)
    |> remove_insignificant_zeroes_from_string()
  end

  defp remove_insignificant_zeroes_from_string(humanized_number) do
    # Splits at `.00` or insigificant zero in humanized number
    # Eg:
    # "100.00 Million" => ["100", " Million"]
    # "100.50 Million" => ["100.5", " Million"]
    case String.split(humanized_number, ~r{(\.00)|(?<=\.[1-9])0}) do
      [whole_number, string_units] -> whole_number <> string_units
      [number] -> number
    end
  end
end
