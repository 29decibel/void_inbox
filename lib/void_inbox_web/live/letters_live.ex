defmodule VoidInboxWeb.LettersLive do
  use VoidInboxWeb, :live_view

  def mount(_params, _session, socket) do
    current_user = socket.assigns[:current_user]
    # get current user

    {:ok, assign(socket, letters: VoidInbox.Letters.list_letters(current_user.id))}
  end
end
