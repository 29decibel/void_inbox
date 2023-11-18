defmodule VoidInboxWeb.LettersLive do
  use VoidInboxWeb, :live_view

  def mount(_params, _session, socket) do
    current_user = socket.assigns[:current_user]
    # get current user

    {:ok, assign(socket, letters: VoidInbox.Letters.list_letters(current_user.id))}
  end

  def handle_event("mark-read", %{"id" => letter_id}, socket) do
    letter = VoidInbox.Letters.get_letter!(letter_id)

    {:ok, new_letter} =
      VoidInbox.Letters.update_letter(letter, %{
        read: true
      })

    IO.inspect(new_letter)

    # swap the new letter in the list
    letters = socket.assigns[:letters]

    new_letters =
      Enum.map(letters, fn l ->
        if l.id == new_letter.id do
          new_letter
        else
          l
        end
      end)

    {:noreply, assign(socket, letters: new_letters)}
  end

  def first_letter(str) do
    str
    |> String.graphemes()
    |> Enum.find(&(&1 =~ ~r/[[:alpha:]]/))
    |> String.upcase()
  end
end
