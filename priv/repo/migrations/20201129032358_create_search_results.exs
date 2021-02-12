defmodule GSearcher.Repo.Migrations.CreateSearchResults do
  use Ecto.Migration

  def change do
    create table(:search_results) do
      add :search_term, :string
      add :total_number_results, :integer
      add :number_of_results_on_page, :integer
      add :all_urls, {:array, :string}
      add :html_cache, :text

      add :number_of_top_advertisers, :integer
      add :top_advertiser_urls, {:array, :string}
      add :total_number_of_advertisers, :integer
      add :advertiser_urls, {:array, :string}

      timestamps()
    end
  end
end
