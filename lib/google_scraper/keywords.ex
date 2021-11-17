defmodule GoogleScraper.Keywords do
  @moduledoc """
  The Keywords context.
  """

  import Ecto.Query, warn: false
  alias GoogleScraper.Repo

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

  def bulk_create_keywords(attrs, entity) do
    attrs
    |> Enum.map(fn entry ->
      entity.changeset(entity.__struct__(), entry)
    end)
    |> Enum.with_index()
    |> Enum.reduce(
      Ecto.Multi.new(),
      fn {changeset, index}, multi ->
        Ecto.Multi.insert(multi, Integer.to_string(index), changeset, on_conflict: :nothing)
      end
    )
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        %{rows_affected: length(attrs), errors: []}

      {
        :error,
        _,
        %Ecto.Changeset{
          changes: changes,
          errors: errors
        },
        _
      } ->
        %{
          rows_affected: 0,
          errors: "Changes #{changes} couldn't be created because #{inspect(errors)}"
        }
    end
  end

  @doc """
  Finds if there's keywords that produced no results, which are tagged as nil.
  Then removes them from the list and only inserts the keywords with results.
  """
  def maybe_insert_keywords(results) do
    case Enum.member?(results, nil) do
      false ->
        bulk_create_keywords(results, GoogleScraper.Keywords.Keyword)

      true ->
        results
        |> Enum.filter(&(&1 != nil))
        |> bulk_create_keywords(GoogleScraper.Keywords.Keyword)
    end
  end
end
