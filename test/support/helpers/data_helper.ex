defmodule GSearcher.Helpers.DataHelper do
  def forget(struct, field, cardinality \\ :many) do
    %{
      struct
      | field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
    }
  end
end
