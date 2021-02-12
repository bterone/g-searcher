defmodule GSearcher.Repo.Migrations.UpdateSearchResultColumnsToTextArray do
  use Ecto.Migration

  def change do
    alter table(:search_results) do
      modify :search_result_urls, {:array, :text}
      modify :top_advertiser_urls, {:array, :text}
      modify :regular_advertiser_urls, {:array, :text}
    end
  end
end
