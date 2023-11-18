defmodule VoidInbox.LettersTest do
  use VoidInbox.DataCase

  alias VoidInbox.Letters

  describe "letters" do
    alias VoidInbox.Letters.Letter

    import VoidInbox.LettersFixtures

    @invalid_attrs %{read: nil, raw_message: nil, to_email: nil, from_email: nil, html_content: nil, text_content: nil, subject: nil}

    test "list_letters/0 returns all letters" do
      letter = letter_fixture()
      assert Letters.list_letters() == [letter]
    end

    test "get_letter!/1 returns the letter with given id" do
      letter = letter_fixture()
      assert Letters.get_letter!(letter.id) == letter
    end

    test "create_letter/1 with valid data creates a letter" do
      valid_attrs = %{read: true, raw_message: %{}, to_email: "some to_email", from_email: "some from_email", html_content: "some html_content", text_content: "some text_content", subject: "some subject"}

      assert {:ok, %Letter{} = letter} = Letters.create_letter(valid_attrs)
      assert letter.read == true
      assert letter.raw_message == %{}
      assert letter.to_email == "some to_email"
      assert letter.from_email == "some from_email"
      assert letter.html_content == "some html_content"
      assert letter.text_content == "some text_content"
      assert letter.subject == "some subject"
    end

    test "create_letter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Letters.create_letter(@invalid_attrs)
    end

    test "update_letter/2 with valid data updates the letter" do
      letter = letter_fixture()
      update_attrs = %{read: false, raw_message: %{}, to_email: "some updated to_email", from_email: "some updated from_email", html_content: "some updated html_content", text_content: "some updated text_content", subject: "some updated subject"}

      assert {:ok, %Letter{} = letter} = Letters.update_letter(letter, update_attrs)
      assert letter.read == false
      assert letter.raw_message == %{}
      assert letter.to_email == "some updated to_email"
      assert letter.from_email == "some updated from_email"
      assert letter.html_content == "some updated html_content"
      assert letter.text_content == "some updated text_content"
      assert letter.subject == "some updated subject"
    end

    test "update_letter/2 with invalid data returns error changeset" do
      letter = letter_fixture()
      assert {:error, %Ecto.Changeset{}} = Letters.update_letter(letter, @invalid_attrs)
      assert letter == Letters.get_letter!(letter.id)
    end

    test "delete_letter/1 deletes the letter" do
      letter = letter_fixture()
      assert {:ok, %Letter{}} = Letters.delete_letter(letter)
      assert_raise Ecto.NoResultsError, fn -> Letters.get_letter!(letter.id) end
    end

    test "change_letter/1 returns a letter changeset" do
      letter = letter_fixture()
      assert %Ecto.Changeset{} = Letters.change_letter(letter)
    end
  end
end
