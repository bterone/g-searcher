defmodule GSearcher.SearchResults.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "search_results" do
    field :search_term, :string
    field :total_number_results, :integer
    field :number_of_results_on_page, :integer
    field :all_urls, {:array, :string}
    field :html_cache, :string

    # Top positioned advertisers
    field :number_of_top_advertisers, :integer
    field :top_advertiser_urls, {:array, :string}

    # All advertisers
    field :total_number_of_advertisers, :integer
    field :advertiser_urls, {:array, :string}

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
      :total_number_of_advertisers,
      :total_number_results,
      :top_advertiser_urls,
      :advertiser_urls,
      :all_urls,
      :html_cache
    ])
    |> validate_required([
      :search_term,
      :number_of_results_on_page,
      :number_of_top_advertisers,
      :total_number_of_advertisers,
      :total_number_results,
      :html_cache
    ])
  end
end
