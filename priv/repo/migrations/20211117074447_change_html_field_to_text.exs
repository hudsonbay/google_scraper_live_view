defmodule GoogleScraper.Repo.Migrations.ChangeHtmlFieldToText do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      modify :html_content, :text
    end
  end
end
