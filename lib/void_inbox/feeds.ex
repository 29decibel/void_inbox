defmodule VoidInbox.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias VoidInbox.Repo

  alias VoidInbox.Feeds.Feed

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds(user_id) do
    from(f in Feed, where: f.user_id == ^user_id) |> Repo.all()
  end

  @doc """
  Gets a single feed.

  Raises `Ecto.NoResultsError` if the Feed does not exist.

  ## Examples

      iex> get_feed!(123)
      %Feed{}

      iex> get_feed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed!(id), do: Repo.get!(Feed, id)

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(attrs \\ %{}) do
    %Feed{}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end

  def create_feed_for_user(user_id) do
    create_feed(%{user_id: user_id, slug: RandomStringGenerator.random_friendly_string()})
  end

  def get_feed_by_slug(slug) do
    from(f in Feed, where: f.slug == ^slug) |> Repo.one()
  end

  @doc """
  Updates a feed.

  ## Examples

      iex> update_feed(feed, %{field: new_value})
      {:ok, %Feed{}}

      iex> update_feed(feed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed(%Feed{} = feed, attrs) do
    feed
    |> Feed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feed.

  ## Examples

      iex> delete_feed(feed)
      {:ok, %Feed{}}

      iex> delete_feed(feed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed(%Feed{} = feed) do
    Repo.delete(feed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed changes.

  ## Examples

      iex> change_feed(feed)
      %Ecto.Changeset{data: %Feed{}}

  """
  def change_feed(%Feed{} = feed, attrs \\ %{}) do
    Feed.changeset(feed, attrs)
  end

  alias VoidInbox.Letters

  # create atom json feed from Feed
  def atom_json_feed(%Feed{user_id: user_id}, feed_url) do
    letters = Letters.list_letters(user_id)

    %{
      "version" => "https://jsonfeed.org/version/1",
      "title" => "📨 Void Inbox",
      "home_page_url" => feed_url,
      "feed_url" => feed_url,
      "items" => letters |> Enum.map(&atom_json_item/1)
    }
  end

  defp atom_json_item(%Letters.Letter{
         subject: subject,
         from_email: from_email,
         from_name: from_name,
         html_content: html_content,
         text_content: text_content,
         date: received_at,
         id: id
       }) do
    %{
      "id" => id,
      "title" => subject,
      "author" => %{
        "name" => from_name,
        "email" => from_email
      },
      "content_text" =>
        if html_content == nil do
          text_content
        else
          html_content
        end,
      "date_published" => received_at
    }
  end
end
