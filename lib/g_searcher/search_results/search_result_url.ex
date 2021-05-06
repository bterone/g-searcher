defmodule GSearcher.SearchResults.SearchResultURL do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSearcher.SearchResults.SearchResult

  schema "search_result_urls" do
    field :title, :string
    field :url, :string

    field :is_top_ad, :boolean, default: false
    field :is_regular_ad, :boolean, default: false

    belongs_to :search_result, SearchResult

    timestamps()
  end

  def create_changeset(search_result_url \\ %__MODULE__{}, attrs) do
    search_result_url
    |> cast(attrs, [:title, :url, :is_top_ad, :is_regular_ad, :search_result_id])
    |> validate_required([:title, :url, :search_result_id])
    |> validate_top_or_regular_ad()
  end

  defp validate_top_or_regular_ad(changeset) do
    {_, is_top_ad} = fetch_field(changeset, :is_top_ad)

    validate_change(changeset, :is_regular_ad, fn _, is_regular_ad ->
      if is_regular_ad && is_top_ad do
        [is_regular_ad: "cannot be both top and regular ad"]
      else
        []
      end
    end)
  end
end
