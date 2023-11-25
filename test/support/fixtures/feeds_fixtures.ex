defmodule VoidInbox.FeedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VoidInbox.Feeds` context.
  """

  @doc """
  Generate a unique feed slug.
  """
  def unique_feed_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    {:ok, feed} =
      attrs
      |> Enum.into(%{
        slug: unique_feed_slug()
      })
      |> VoidInbox.Feeds.create_feed()

    feed
  end
end
