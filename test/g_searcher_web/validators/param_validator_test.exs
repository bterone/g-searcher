defmodule GSearcherWeb.Validators.ParamValidatorTest do
  use GSearcher.DataCase

  alias GSearcherWeb.Validators.ParamValidator

  defmodule PersonTest do
    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field :name, :string
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name])
      |> validate_required(:name)
    end
  end

  describe "validate/2" do
    test "returns {:ok, attrs} given valid params" do
      params = %{
        "name" => "John Smith"
      }

      assert {:ok, %{name: "John Smith"}} = ParamValidator.validate(params, for: PersonTest)
    end

    test "returns {:error, :invalid_params, changeset} given invalid params" do
      params = %{
        "name" => ""
      }

      assert {:error, :invalid_params, changeset} =
               ParamValidator.validate(params, for: PersonTest)

      assert changeset.valid? == false
      assert changeset.action == :validate
    end
  end
end
