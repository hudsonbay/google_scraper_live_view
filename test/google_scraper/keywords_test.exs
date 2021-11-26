defmodule GoogleScraper.KeywordsTest do
  use GoogleScraper.DataCase

  alias GoogleScraper.Keywords
  alias GoogleScraper.KeywordsFixtures

  describe "keywords" do
    test "list_keywords/1 returns all keywords" do
      {user_id, keyword} = KeywordsFixtures.keyword_fixture()
      assert Keywords.list_keywords_by_user(user_id) == [keyword]
    end

    test "search_by_name/2 returns all the keywords matching the name attribute" do
      {user_id, keyword} = KeywordsFixtures.keyword_fixture()
      assert Keywords.search_by_name(keyword.name, user_id) == [keyword]
    end

    test "search_by_name/2 returns an empty list if the keywords don't match the name attribute" do
      {user_id, _keyword} = KeywordsFixtures.keyword_fixture()
      assert Keywords.search_by_name("this name doesn't exist", user_id) == []
    end
  end
end
