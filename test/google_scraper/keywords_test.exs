defmodule GoogleScraper.KeywordsTest do
  use GoogleScraper.DataCase

  alias GoogleScraper.Keywords

  describe "keywords" do
    alias GoogleScraper.Keywords.Keyword

    import GoogleScraper.KeywordsFixtures

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Keywords.list_keywords() == [keyword]
    end
  end
end
