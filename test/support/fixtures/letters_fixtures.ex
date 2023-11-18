defmodule VoidInbox.LettersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VoidInbox.Letters` context.
  """

  @doc """
  Generate a letter.
  """
  def letter_fixture(attrs \\ %{}) do
    {:ok, letter} =
      attrs
      |> Enum.into(%{
        from_email: "some from_email",
        html_content: "some html_content",
        raw_message: %{},
        read: true,
        subject: "some subject",
        text_content: "some text_content",
        to_email: "some to_email"
      })
      |> VoidInbox.Letters.create_letter()

    letter
  end
end
