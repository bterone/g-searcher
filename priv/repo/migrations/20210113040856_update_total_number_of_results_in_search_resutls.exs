defmodule GSearcher.Repo.Migrations.UpdateTotalNumberOfResultsInSearchResutls do
  use Ecto.Migration

  def change do
    alter table(:search_results) do
      modify :total_number_of_results, :bigint
    end
  end
end
