defmodule VoidInbox.VoidEmails do
  @moduledoc """
  The VoidEmails context.
  """

  import Ecto.Query, warn: false
  alias VoidInbox.Repo

  alias VoidInbox.VoidEmails.VoidEmail

  @doc """
  Returns the list of void_emails.

  ## Examples

      iex> list_void_emails()
      [%VoidEmail{}, ...]

  """
  def list_void_emails do
    Repo.all(VoidEmail)
  end

  @doc """
  Gets a single void_email.

  Raises `Ecto.NoResultsError` if the Void email does not exist.

  ## Examples

      iex> get_void_email!(123)
      %VoidEmail{}

      iex> get_void_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_void_email!(id), do: Repo.get!(VoidEmail, id)

  @doc """
  Creates a void_email.

  ## Examples

      iex> create_void_email(%{field: value})
      {:ok, %VoidEmail{}}

      iex> create_void_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_void_email(attrs \\ %{}) do
    %VoidEmail{}
    |> VoidEmail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a void_email.

  ## Examples

      iex> update_void_email(void_email, %{field: new_value})
      {:ok, %VoidEmail{}}

      iex> update_void_email(void_email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_void_email(%VoidEmail{} = void_email, attrs) do
    void_email
    |> VoidEmail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a void_email.

  ## Examples

      iex> delete_void_email(void_email)
      {:ok, %VoidEmail{}}

      iex> delete_void_email(void_email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_void_email(%VoidEmail{} = void_email) do
    Repo.delete(void_email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking void_email changes.

  ## Examples

      iex> change_void_email(void_email)
      %Ecto.Changeset{data: %VoidEmail{}}

  """
  def change_void_email(%VoidEmail{} = void_email, attrs \\ %{}) do
    VoidEmail.changeset(void_email, attrs)
  end
end
