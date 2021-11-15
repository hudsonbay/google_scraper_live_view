defmodule GoogleScraper.Keywords.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias GoogleScraper.Accounts.User

  schema "keywords" do
    field :html_content, :string
    field :name, :string
    field :total_advertisers, :integer
    field :total_links, :integer
    field :total_results, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [
      :name,
      :total_advertisers,
      :total_links,
      :total_results,
      :html_content,
      :user_id
    ])
    |> validate_required([
      :name,
      :total_advertisers,
      :total_links,
      :total_results,
      :html_content,
      :user_id
    ])
    |> assoc_constraint(:user)
  end
end
