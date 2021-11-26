defmodule GoogleScraper.KeywordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoogleScraper.Keywords` context.
  """
  alias GoogleScraper.AccountsFixtures
  alias GoogleScraper.Keywords

  @doc """
  Generate a keyword.
  """
  def keyword_fixture() do
    user = AccountsFixtures.user_fixture()

    keyword = %{
      html_content: "h1",
      total_advertisers: 5,
      total_links: 88,
      total_results: "About 19,300,000 results (0.58 seconds)",
      name: "dell xps",
      user_id: user.id
    }

    Keywords.create_keyword(keyword)

    {user.id,
     %{
       total_advertisers: 5,
       total_links: 88,
       total_results: "About 19,300,000 results (0.58 seconds)",
       name: "dell xps"
     }}
  end

  def keyword_fixture(user) do
    keyword = %{
      html_content: "h1",
      total_advertisers: 5,
      total_links: 88,
      total_results: "About 19,300,000 results (0.58 seconds)",
      name: "dell xps",
      user_id: user.id
    }

    Keywords.create_keyword(keyword)

    {user.id,
     %{
       total_advertisers: 5,
       total_links: 88,
       total_results: "About 19,300,000 results (0.58 seconds)",
       name: "dell xps"
     }}
  end
end
