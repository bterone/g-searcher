defmodule GSearcher.Repo.Migrations.RenameSearchResultColumns do
  use Ecto.Migration

  def change do
    rename table(:search_results), :all_urls, to: :search_result_urls

    rename table(:search_results), :total_number_of_advertisers,
      to: :number_of_regular_advertisers

    rename table(:search_results), :advertiser_urls, to: :regular_advertiser_urls
    rename table(:search_results), :total_number_results, to: :total_number_of_results
  end
end
