defmodule GSearcherWeb.Helpers.SearchHelper do
  @spaces_outside_double_quotes ~r{\s+(?=([^"]*"[^"]*")*[^"]*$)}
  @valid_operators ["title", "url", "top_ads", "regular_ads", "status"]

  @spec parse_query(String.t()) :: {:ok, %{String.t() => String.t()}}
  def parse_query(query) when is_binary(query) do
    parsed_query =
      query
      |> escape_percentage_sign()
      |> split_string_by_space()
      |> convert_search_options_to_map()
      |> build_query_attributes()

    {:ok, parsed_query}
  end

  defp escape_percentage_sign(string), do: String.replace(string, "%", "\\%")

  defp split_string_by_space(query) when is_binary(query),
    do: Regex.split(@spaces_outside_double_quotes, query)

  defp convert_search_options_to_map(query_list) when is_list(query_list) do
    Enum.map(query_list, fn query ->
      case String.split(query, ":", parts: 2) do
        [search_operator, query_param] ->
          convert_search_options_to_map(search_operator, query_param)

        [result] ->
          result
      end
    end)
  end

  # Trims double quotes from query
  defp convert_search_options_to_map(operator, query_param) when operator in @valid_operators do
    trimmed_param = String.trim(query_param, "\"")

    %{operator => trimmed_param}
  end

  defp convert_search_options_to_map(operator, query_param),
    do: operator <> ":" <> query_param

  defp build_query_attributes(query_list) when is_list(query_list) do
    query = join_non_operator_filters(query_list)
    search_params = Enum.filter(query_list, &is_map/1)
    combined_search_params = [%{"query" => query}] ++ search_params

    Enum.reduce(combined_search_params, fn search_option, acc ->
      Map.merge(search_option, acc)
    end)
  end

  defp join_non_operator_filters(list) do
    list
    |> Enum.reject(&is_map/1)
    |> Enum.join(" ")
  end
end
