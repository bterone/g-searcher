defmodule GSearcher.SearchResults.SearchResultUrl do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSearcher.SearchResults.SearchResult

  schema "search_result_urls" do
    field :title, :string
    field :url, :string

    field :is_top_ad, :boolean
    field :is_regular_ad, :boolean

    belongs_to :search_result, SearchResult

    timestamps()
  end
end
