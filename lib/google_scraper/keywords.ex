defmodule GoogleScraper.Keywords do
  @moduledoc """
  The Keywords context.
  """

  import Ecto.Query, warn: false
  alias GoogleScraper.Repo
  alias GoogleScraper.Keywords.Keyword, as: K

  @topic "keyword_list"
  @pubsub GoogleScraper.PubSub

  def search_by_name(name, user_id) do
    list_keywords_by_user(user_id)
    |> Enum.filter(&(&1.name =~ name))
  end

  def list_keywords_by_user(user_id) do
    case user_id do
      nil ->
        []

      _ ->
        q =
          from "keywords",
            where: [user_id: ^user_id],
            select: [:name, :total_advertisers, :total_links, :total_results]

        Repo.all(q)
    end
  end

  @doc """
  Creates a keyword.
  """
  def create_keyword(attrs \\ %{}) do
    %K{}
    |> K.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:keyword_created)
  end

  def broadcast({:error, _c} = error, _event), do: error

  def broadcast({:ok, keyword}, event) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      @topic,
      {event, keyword}
    )

    {:ok, keyword}
  end

  def subscribe, do: Phoenix.PubSub.subscribe(@pubsub, @topic, link: true)

  @doc """
  Validates keyword insertion only if it's non-null
  """
  def maybe_insert_keyword(keyword) do
    if keyword != nil do
      create_keyword(keyword)
    end
  end
end
