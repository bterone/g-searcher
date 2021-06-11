defmodule GSearcherWeb.Validators.ParamsValidatorTest do
  use GSearcher.DataCase

  alias GSearcherWeb.Validators.ParamsValidator

  defmodule CreateDeveloperParams do
    use Ecto.Schema

    import Ecto.Changeset

    alias GSearcherWeb.Validators.ParamsValidatorTest.CreateLanguageParams

    embedded_schema do
      field(:name, :string)
      embeds_many(:languages, CreateLanguageParams)
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name])
      |> cast_embed(:languages, with: &CreateLanguageParams.changeset/2, required: true)
      |> validate_required([:name])
    end
  end

  defmodule CreateLanguageParams do
    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field(:name, :string)
    end

    def changeset(data \\ %__MODULE__{}, params) do
      data
      |> cast(params, [:name])
      |> validate_required([:name])
      |> validate_inclusion(:name, ["elixir", "ruby", "elm"])
    end
  end

  describe "validate/2" do
    test "returns {:error, :invalid_params, changeset} if the given params is invalid" do
      params = %{
        "name" => nil,
        "languages" => [
          %{
            "name" => "java"
          },
          %{
            "name" => ""
          }
        ]
      }

      result = ParamsValidator.validate(params, as: CreateDeveloperParams)

      assert {:error, :invalid_params, changeset} = result
      assert changeset.valid? == false
      assert changeset.action == :validate

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               languages: [
                 %{
                   name: ["is invalid"]
                 },
                 %{
                   name: ["can't be blank"]
                 }
               ]
             }
    end

    test "sets action to changeset if the given params invalid" do
      params = %{}

      result = ParamsValidator.validate(params, as: CreateDeveloperParams)

      assert {:error, :invalid_params, changeset} = result

      assert changeset.valid? == false
      assert changeset.action == :validate
    end

    test "returns {:ok, validated_params} if the given params is valid" do
      params = %{
        "name" => "Jo",
        "languages" => [
          %{
            "name" => "elixir"
          },
          %{
            "name" => "ruby"
          }
        ]
      }

      result = ParamsValidator.validate(params, as: CreateDeveloperParams)

      assert {:ok, validated_params} = result

      assert validated_params == %{
               name: "Jo",
               languages: [
                 %{
                   name: "elixir"
                 },
                 %{
                   name: "ruby"
                 }
               ]
             }
    end
  end
end
