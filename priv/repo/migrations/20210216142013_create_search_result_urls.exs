defmodule GSearcher.Repo.Migrations.CreateSearchResultUrls do
  use Ecto.Migration

  def change do
    create table(:search_result_urls) do
      add :title, :text
      add :url, :text
      add :is_top_ad, :boolean, default: false
      add :is_regular_ad, :boolean, default: false

      add :search_result_id, references(:search_results)

      timestamps()
    end
  end
end
