defmodule GoogleScraper.Repo.Migrations.ChangeTotalResultsColumnType do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      modify :total_results, :string
    end
  end
end
