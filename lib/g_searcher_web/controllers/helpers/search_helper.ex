defmodule GSearcherWeb.Helpers.SearchHelper do
  @valid_operators ["title", "url", "top_ads", "regular_ads", "status"]

  @spec parse_query(String.t()) ::
          %{
            query: String.t(),
            title: String.t(),
            url: String.t(),
            top_ads: String.t(),
            regular_ads: String.t(),
            status: String.t()
          }
  def parse_query(query) when is_binary(query) do
    query
    |> split_by_space(ignore_in_double_quotes: true)
    |> convert_search_options_to_map()
    |> build_query_attributes()
  end

  defp split_by_space(query, ignore_in_double_quotes: true) when is_binary(query),
    do: Regex.split(~r{\s+(?=([^"]*"[^"]*")*[^"]*$)}, query)

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

  defp convert_search_options_to_map(operator, query_param) when operator in @valid_operators do
    trimmed_param = String.trim(query_param, "\"")

    %{cast_operator(operator) => trimmed_param}
  end

  defp convert_search_options_to_map(operator, query_param),
    do: operator <> ":" <> query_param

  defp build_query_attributes(query_list) when is_list(query_list) do
    query =
      query_list
      |> Enum.reject(&is_map/1)
      |> Enum.join(" ")

    search_params = Enum.filter(query_list, &is_map/1)

    Enum.reduce([%{query: query}] ++ search_params, fn search_option, acc ->
      Map.merge(search_option, acc)
    end)
  end

  defp cast_operator("title"), do: :title
  defp cast_operator("url"), do: :url
  defp cast_operator("top_ads"), do: :top_ads
  defp cast_operator("regular_ads"), do: :regular_ads
  defp cast_operator("status"), do: :status
end
