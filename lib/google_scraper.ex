defmodule GoogleScraper do
  @moduledoc """
  GoogleScraper keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @base_url "https://www.google.com/search?q="
  @max_sleep_time 5_000

  def fetch_results(keyword_list, user_id) do
    Enum.map(keyword_list, fn keyword ->
      @max_sleep_time
      |> :rand.uniform()
      |> Process.sleep()

      IO.puts("fetching #{keyword} from Google...")

      keyword
      |> scrap(user_id)
      |> build_keyword_map()
    end)
  end

  def scrap(keyword, user_id) do
    response = Crawly.fetch(@base_url <> URI.encode_query(%{"" => keyword}))

    body = Codepagex.from_string!(response.body, :iso_8859_1, Codepagex.use_utf_replacement())

    %{
      "document" => Floki.parse_document!(body),
      "keyword" => keyword,
      "user_id" => user_id
    }
  end

  defp build_keyword_map(%{
         "document" => document,
         "keyword" => keyword,
         "user_id" => user_id
       }) do
    IO.puts("Building keyword map for keyword: #{keyword} ...")

    total_results =
      document
      |> Floki.find("#result-stats")
      |> Floki.text()
      |> String.trim(" ")

    total_links =
      document
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.count()

    %{
      html_content: "<h1>Hello</h1>",
      total_results: total_results,
      name: keyword,
      total_links: total_links,
      total_advertisers: 5,
      user_id: user_id
    }
  end
end
