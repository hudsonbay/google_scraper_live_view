defmodule GoogleScraper.Keywords do
  @moduledoc """
  The Keywords context.
  """

  import Ecto.Query, warn: false
  alias GoogleScraper.Repo

  alias GoogleScraper.Keywords.Keyword

  @doc """
  Returns the list of keywords.

  ## Examples

      iex> list_keywords()
      [%Keyword{}, ...]

  """
  def list_keywords do
    Repo.all(Keyword)
  end

  def bulk_create_keywords(entity, attrs) do
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
end
