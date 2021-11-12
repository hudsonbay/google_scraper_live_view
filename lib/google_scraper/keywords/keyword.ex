defmodule GoogleScraper.Keywords.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :html_content, :string
    field :name, :string
    field :total_advertisers, :integer
    field :total_links, :integer
    field :total_results, :integer

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:name, :total_advertisers, :total_links, :total_results, :html_content])
    |> validate_required([:name, :total_advertisers, :total_links, :total_results, :html_content])
  end
end
