defmodule GoogleScraper.Repo.Migrations.AddKeywordsToUsers do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      add :user_id, references(:users, on_delete: :delete_all),
        null: false
    end

    create index(:keywords, [:user_id])

  end
end
