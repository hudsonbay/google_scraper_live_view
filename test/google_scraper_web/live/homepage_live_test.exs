defmodule GoogleScraper.HomePageLiveTest do
  use ExUnit.Case
  use GoogleScraperWeb.ConnCase

  import Phoenix.LiveViewTest

  @index_leading_title "<h1 class=\"my-4 text-2xl md:text-3xl lg:text-5xl font-black leading-tight\">\n        Google web scraper\n      </h1>"

  describe "index" do
    test "when the app starts the main title is shown", %{conn: conn} do
      %{conn: conn} = register_and_log_in_user(%{conn: conn})

      {:ok, _index_live, html} = live(conn, Routes.homepage_index_path(conn, :index))
      assert html =~ @index_leading_title
    end

    test "when the app starts the keyword list is provided for the user in a table", %{conn: conn} do
      %{conn: conn, user: user} = register_and_log_in_user(%{conn: conn})

      GoogleScraper.KeywordsFixtures.keyword_fixture(user)

      {:ok, _index_live, html} = live(conn, Routes.homepage_index_path(conn, :index))
      assert html =~ "dell xps"
      assert html =~ "About 19,300,000 results (0.58 seconds)"
    end
  end
end
