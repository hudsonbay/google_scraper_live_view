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

  @doc """
  Gets a single keyword.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123)
      %Keyword{}

      iex> get_keyword!(456)
      ** (Ecto.NoResultsError)

  """
  def get_keyword!(id), do: Repo.get!(Keyword, id)

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a keyword.

  ## Examples

      iex> update_keyword(keyword, %{field: new_value})
      {:ok, %Keyword{}}

      iex> update_keyword(keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a keyword.

  ## Examples

      iex> delete_keyword(keyword)
      {:ok, %Keyword{}}

      iex> delete_keyword(keyword)
      {:error, %Ecto.Changeset{}}

  """
  def delete_keyword(%Keyword{} = keyword) do
    Repo.delete(keyword)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking keyword changes.

  ## Examples

      iex> change_keyword(keyword)
      %Ecto.Changeset{data: %Keyword{}}

  """
  def change_keyword(%Keyword{} = keyword, attrs \\ %{}) do
    Keyword.changeset(keyword, attrs)
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
