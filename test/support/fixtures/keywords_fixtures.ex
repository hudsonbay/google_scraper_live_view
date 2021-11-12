defmodule GoogleScraper.KeywordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoogleScraper.Keywords` context.
  """

  @doc """
  Generate a keyword.
  """
  def keyword_fixture(attrs \\ %{}) do
    {:ok, keyword} =
      attrs
      |> Enum.into(%{
        html_content: "some html_content",
        name: "some name",
        total_advertisers: 42,
        total_links: 42,
        total_results: 42
      })
      |> GoogleScraper.Keywords.create_keyword()

    keyword
  end
end
