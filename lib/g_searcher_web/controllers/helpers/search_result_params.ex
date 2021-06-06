defmodule GSearcherWeb.Helpers.SearchResultParams do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  @valid_quantity_operators ["<", ">", "="]

  embedded_schema do
    field :search_term, :string
    field :title, :string
    field :url, :string
    field :top_ads, :string
    field :regular_ads, :string
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:title, :url, :top_ads, :regular_ads])
    |> put_change(:search_term, params["query"])
    |> is_count_operation?(:top_ads)
    |> is_count_operation?(:regular_ads)
  end

  defp is_count_operation?(changeset, field) do
    validate_change(changeset, field, fn _, operation ->
      with true <- contains_quantity_operator?(operation),
           true <- value_is_number?(operation) do
        []
      else
        {false, :invalid_operator} ->
          [{field, {"operation should only be '<, >, ='", [validation: :invalid_operator]}}]

        {false, :invalid_value} ->
          [{field, {"operation should use a number", [validation: :invalid_value]}}]
      end
    end)
  end

  defp contains_quantity_operator?(<<operator::binary-size(1), _::binary>>)
       when operator in @valid_quantity_operators,
       do: true

  defp contains_quantity_operator?(_), do: {false, :invalid_operator}

  defp value_is_number?(<<_::binary-size(1), value::binary>>) do
    value
    |> String.to_integer()
    |> is_integer()
  rescue
    ArgumentError ->
      {false, :invalid_value}
  end
end
