defmodule GSearcher.Helpers.DataHelper do
  @doc """
  Removes all associated preloaded records and replaces with Ecto.Association.Unloaded
  """
  def forget_associations(struct) do
    associations = resolve_associations(struct)
    forget(struct, associations)
  end

  def forget(struct, associations) when is_list(associations) do
    associations
    |> Enum.reduce(struct, fn association, struct ->
      forget(struct, association)
    end)
  end

  def forget(struct, association) do
    %{
      struct
      | association => build_not_loaded(struct, association)
    }
  end

  defp resolve_associations(%{__struct__: schema}) do
    schema.__schema__(:associations)
  end

  defp build_not_loaded(%{__struct__: schema}, association) do
    %{
      cardinality: cardinality,
      field: field,
      owner: owner
    } = schema.__schema__(:association, association)

    %Ecto.Association.NotLoaded{
      __cardinality__: cardinality,
      __field__: field,
      __owner__: owner
    }
  end
end
