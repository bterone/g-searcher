defmodule GSearcher.Repo.Migrations.RemoveURLColumnFromSearchResults do
  use Ecto.Migration

  def up do
    alter table(:search_results) do
      remove :top_advertiser_urls
      remove :regular_advertiser_urls
      remove :search_result_urls
    end
  end

  def down do
    alter table(:search_results) do
      add :top_advertiser_urls, {:array, :text}
      add :regular_advertiser_urls, {:array, :text}
      add :search_result_urls, {:array, :text}
    end
  end
end
