defmodule GSearcher.SearchResults.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "search_results" do
    field :search_term, :string
    field :total_number_of_results, :integer
    field :number_of_results_on_page, :integer
    field :search_result_urls, {:array, :string}
    field :html_cache, :string

    # Top positioned advertisers
    field :number_of_top_advertisers, :integer
    field :top_advertiser_urls, {:array, :string}

    # All advertisers
    field :number_of_regular_advertisers, :integer
    field :regular_advertiser_urls, {:array, :string}

    timestamps()
  end

  def create_keyword_changeset(search_result \\ %__MODULE__{}, attrs) do
    search_result
    |> cast(attrs, [:search_term])
    |> validate_required(:search_term)
  end

  def update_search_result_changeset(search_result, attrs) do
    search_result
    |> cast(attrs, [
      :number_of_results_on_page,
      :number_of_top_advertisers,
      :number_of_regular_advertisers,
      :total_number_of_results,
      :top_advertiser_urls,
      :regular_advertiser_urls,
      :search_result_urls,
      :html_cache
    ])
    |> validate_required([
      :search_term,
      :number_of_results_on_page,
      :number_of_top_advertisers,
      :number_of_regular_advertisers,
      :total_number_of_results,
      :html_cache
    ])
  end
end
