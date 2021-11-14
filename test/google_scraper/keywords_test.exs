defmodule GoogleScraper.KeywordsTest do
  use GoogleScraper.DataCase

  alias GoogleScraper.Keywords

  describe "keywords" do
    alias GoogleScraper.Keywords.Keyword

    import GoogleScraper.KeywordsFixtures

    @invalid_attrs %{
      html_content: nil,
      name: nil,
      total_advertisers: nil,
      total_links: nil,
      total_results: nil
    }

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Keywords.list_keywords() == [keyword]
    end

    test "get_keyword!/1 returns the keyword with given id" do
      keyword = keyword_fixture()
      assert Keywords.get_keyword!(keyword.id) == keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      valid_attrs = %{
        html_content: "some html_content",
        name: "some name",
        total_advertisers: 42,
        total_links: 42,
        total_results: "Cerca de 923,000 resultados (0.54 segundos)"
      }

      assert {:ok, %Keyword{} = keyword} = Keywords.create_keyword(valid_attrs)
      assert keyword.html_content == "some html_content"
      assert keyword.name == "some name"
      assert keyword.total_advertisers == 42
      assert keyword.total_links == 42
      assert keyword.total_results == "Cerca de 923,000 resultados (0.54 segundos)"
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Keywords.create_keyword(@invalid_attrs)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = keyword_fixture()

      update_attrs = %{
        html_content: "some updated html_content",
        name: "some updated name",
        total_advertisers: 43,
        total_links: 43,
        total_results: "Cerca de 923,000 resultados (0.54 segundos)"
      }

      assert {:ok, %Keyword{} = keyword} = Keywords.update_keyword(keyword, update_attrs)
      assert keyword.html_content == "some updated html_content"
      assert keyword.name == "some updated name"
      assert keyword.total_advertisers == 43
      assert keyword.total_links == 43
      assert keyword.total_results == "Cerca de 923,000 resultados (0.54 segundos)"
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = keyword_fixture()
      assert {:error, %Ecto.Changeset{}} = Keywords.update_keyword(keyword, @invalid_attrs)
      assert keyword == Keywords.get_keyword!(keyword.id)
    end

    test "delete_keyword/1 deletes the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{}} = Keywords.delete_keyword(keyword)
      assert_raise Ecto.NoResultsError, fn -> Keywords.get_keyword!(keyword.id) end
    end

    test "change_keyword/1 returns a keyword changeset" do
      keyword = keyword_fixture()
      assert %Ecto.Changeset{} = Keywords.change_keyword(keyword)
    end
  end
end
