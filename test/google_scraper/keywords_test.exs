defmodule GoogleScraper.KeywordsTest do
  use GoogleScraper.DataCase

  alias GoogleScraper.Keywords
  alias GoogleScraper.KeywordsFixtures

  describe "keywords" do
    test "list_keywords/0 returns all keywords" do
      {user_id, keyword} = KeywordsFixtures.keyword_fixture()
      assert Keywords.list_keywords_by_user(user_id) == [keyword]
    end
  end
end
