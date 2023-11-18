defmodule VoidInbox.VoidEmailsTest do
  use VoidInbox.DataCase

  alias VoidInbox.VoidEmails

  describe "void_emails" do
    alias VoidInbox.VoidEmails.VoidEmail

    import VoidInbox.VoidEmailsFixtures

    @invalid_attrs %{name: nil, status: nil}

    test "list_void_emails/0 returns all void_emails" do
      void_email = void_email_fixture()
      assert VoidEmails.list_void_emails() == [void_email]
    end

    test "get_void_email!/1 returns the void_email with given id" do
      void_email = void_email_fixture()
      assert VoidEmails.get_void_email!(void_email.id) == void_email
    end

    test "create_void_email/1 with valid data creates a void_email" do
      valid_attrs = %{name: "some name", status: "some status"}

      assert {:ok, %VoidEmail{} = void_email} = VoidEmails.create_void_email(valid_attrs)
      assert void_email.name == "some name"
      assert void_email.status == "some status"
    end

    test "create_void_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = VoidEmails.create_void_email(@invalid_attrs)
    end

    test "update_void_email/2 with valid data updates the void_email" do
      void_email = void_email_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status"}

      assert {:ok, %VoidEmail{} = void_email} =
               VoidEmails.update_void_email(void_email, update_attrs)

      assert void_email.name == "some updated name"
      assert void_email.status == "some updated status"
    end

    test "update_void_email/2 with invalid data returns error changeset" do
      void_email = void_email_fixture()

      assert {:error, %Ecto.Changeset{}} =
               VoidEmails.update_void_email(void_email, @invalid_attrs)

      assert void_email == VoidEmails.get_void_email!(void_email.id)
    end

    test "delete_void_email/1 deletes the void_email" do
      void_email = void_email_fixture()
      assert {:ok, %VoidEmail{}} = VoidEmails.delete_void_email(void_email)
      assert_raise Ecto.NoResultsError, fn -> VoidEmails.get_void_email!(void_email.id) end
    end

    test "change_void_email/1 returns a void_email changeset" do
      void_email = void_email_fixture()
      assert %Ecto.Changeset{} = VoidEmails.change_void_email(void_email)
    end
  end
end
