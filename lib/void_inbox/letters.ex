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
  def list_letters(user_id) do
    Repo.all(Letter |> where([l], l.user_id == ^user_id) |> order_by(desc: :date))
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

  def create_letter_from_smtp_handler(
        %{
          headers: %{
            "Subject" => subject,
            "Date" => date_string,
            "From" => %{
              name: from_name,
              email: from_email
            },
            "To" => to_email
          },
          body: %{
            text: text_body,
            html: html_body
          }
        } = raw_message
      ) do
    # find to_email first
    with [email_name | _] <- to_email |> String.split("@"),
         void_email when is_map(void_email) <-
           VoidInbox.VoidEmails.get_void_email_by_name(email_name) do
      # here we create the letter for the user
      create_letter(%{
        raw_message: raw_message,
        to_email: to_email,
        from_name: from_name,
        from_email: from_email,
        html_content: html_body,
        text_content: text_body,
        subject: subject,
        date: date_string |> parse_date_string,
        user_id: void_email.user_id
      })
    else
      _ ->
        IO.inspect("no void email found for #{to_email}")
        :error
    end
  end

  # https://jrklein.com/2014/11/18/proper-mail-date-header-formatting-rfc-4021-rfc-2822-rfc-822-and-analysis-of-132k-date-headers/
  # crazy here
  # sometimes the date like this!!  "Date": "Mon, 30 Jan 2023 13:37:55 +0000 (UTC)",
  # sometime date like this Fri, 24 Feb 2023 09:31:36 -0500 (EST)
  # Date: Fri, 9 Sep 2005 16:38:47 -0400 (added by postmaster@attrh1i.attrh.att.com)
  # this is freaking annoying !!! "Wed,  1 Feb 2023 20:07:03 +0000" double space
  # iex(8)> Regex.replace(~r/\(.*\)/, "Fri, 9 Sep 2005 16:38:47 -0400 (added by postmaster@attrh1i.attrh.att.com)", "")
  # "Fri, 9 Sep 2005 16:38:47 -0400 "
  # iex(9)> Regex.replace(~r/\s\(.*\)/, "Fri, 9 Sep 2005 16:38:47 -0400 (added by postmaster@attrh1i.attrh.att.com)", "")
  # "Fri, 9 Sep 2005 16:38:47 -0400"
  def parse_date_string(date_string) when is_binary(date_string),
    # remove the " (EST)" or " (UTC)" part
    do:
      Regex.replace(~r/\s\(.*\)/, date_string, "")
      # remove double space ?
      |> String.replace("  ", " ")
      |> Timex.parse!("{RFC1123}")
end
