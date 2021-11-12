defmodule GoogleScraper.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :name, :string
      add :total_advertisers, :integer
      add :total_links, :integer
      add :total_results, :integer
      add :html_content, :string

      timestamps()
    end
  end
end
