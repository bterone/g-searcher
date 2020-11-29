defmodule GSearcher.Search.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "search_results" do
    field :search_term, :string
    field :number_of_results_on_page, :integer
    field :number_of_top_advertisers, :integer
    field :number_of_urls, :integer
    field :total_number_of_advertisers, :integer
    field :total_number_results, :integer
    field :top_advertiser_urls, {:array, :string}
    field :advertiser_urls, {:array, :string}
    field :html_cache, :string

    timestamps()
  end

  @doc false
  def changeset(search_result, attrs) do
    search_result
    |> cast(attrs, [
      :search_term,
      :number_of_results_on_page,
      :number_of_top_advertisers,
      :number_of_urls,
      :total_number_of_advertisers,
      :total_number_results,
      :top_advertiser_urls,
      :advertiser_urls,
      :html_cache
      ])
    |> validate_required([
      :search_term,
      :number_of_results_on_page,
      :number_of_top_advertisers,
      :number_of_urls,
      :total_number_of_advertisers,
      :total_number_results,
      :top_advertiser_urls,
      :advertiser_urls,
      :html_cache
    ])
  end
end
