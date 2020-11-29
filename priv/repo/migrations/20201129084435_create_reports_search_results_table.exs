defmodule GSearcher.Repo.Migrations.CreateReportsSearchResultsTable do
  use Ecto.Migration

  def change do
    create table(:reports_search_results) do
      add :report_id, references(:reports)
      add :search_result_id, references(:search_results)

      timestamps()
    end
  end
end
