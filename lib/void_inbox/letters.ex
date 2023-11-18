defmodule VoidInbox.Letters do
  @moduledoc """
  The Letters context.
  """

  import Ecto.Query, warn: false
  alias VoidInbox.Repo

  alias VoidInbox.Letters.Letter

  @doc """
  Returns the list of letters.

  ## Examples

      iex> list_letters()
      [%Letter{}, ...]

  """
  def list_letters do
    Repo.all(Letter)
  end

  @doc """
  Gets a single letter.

  Raises `Ecto.NoResultsError` if the Letter does not exist.

  ## Examples

      iex> get_letter!(123)
      %Letter{}

      iex> get_letter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_letter!(id), do: Repo.get!(Letter, id)

  @doc """
  Creates a letter.

  ## Examples

      iex> create_letter(%{field: value})
      {:ok, %Letter{}}

      iex> create_letter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_letter(attrs \\ %{}) do
    %Letter{}
    |> Letter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a letter.

  ## Examples

      iex> update_letter(letter, %{field: new_value})
      {:ok, %Letter{}}

      iex> update_letter(letter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_letter(%Letter{} = letter, attrs) do
    letter
    |> Letter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a letter.

  ## Examples

      iex> delete_letter(letter)
      {:ok, %Letter{}}

      iex> delete_letter(letter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_letter(%Letter{} = letter) do
    Repo.delete(letter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking letter changes.

  ## Examples

      iex> change_letter(letter)
      %Ecto.Changeset{data: %Letter{}}

  """
  def change_letter(%Letter{} = letter, attrs \\ %{}) do
    Letter.changeset(letter, attrs)
  end
end
