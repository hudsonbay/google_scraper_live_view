defmodule GoogleScraper do
  @moduledoc """
  GoogleScraper keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias GoogleScraper.Keywords

  @base_url "https://www.google.com/search?q="
  @max_sleep_time 3_000

  def fetch_results(keywords, user_id) do
    IO.puts("Start fetching data...")
    Enum.each(keywords, fn keyword -> fetch_result(keyword, user_id) end)
  end

  def fetch_result(keyword, user_id) do
    @max_sleep_time
    |> :rand.uniform()
    |> Process.sleep()

    IO.puts("fetching #{keyword} from Google...")

    keyword
    |> scrap(user_id)
    |> build_keyword_map()
    |> Keywords.maybe_insert_keyword()
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

    html =
      document
      |> Floki.raw_html()
      |> Codepagex.from_string!(:iso_8859_1, Codepagex.use_utf_replacement())
      |> String.chunk(:printable)
      |> Enum.filter(&String.printable?/1)
      |> Enum.join()

    case total_results do
      "" ->
        nil

      _ ->
        %{
          html_content: html,
          total_results: total_results,
          name: keyword,
          total_links: total_links,
          total_advertisers: 0,
          user_id: user_id
        }
    end
  end
end
