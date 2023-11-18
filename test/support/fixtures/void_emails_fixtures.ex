defmodule VoidInbox.VoidEmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VoidInbox.VoidEmails` context.
  """

  @doc """
  Generate a unique void_email name.
  """
  def unique_void_email_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a void_email.
  """
  def void_email_fixture(attrs \\ %{}) do
    {:ok, void_email} =
      attrs
      |> Enum.into(%{
        name: unique_void_email_name(),
        status: "some status"
      })
      |> VoidInbox.VoidEmails.create_void_email()

    void_email
  end
end
