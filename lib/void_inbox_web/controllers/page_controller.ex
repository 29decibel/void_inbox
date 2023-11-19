defmodule VoidInboxWeb.PageController do
  use VoidInboxWeb, :controller

  def home(conn, _params) do
    # checking if user already signed in, if so redirect to /inbox
    if conn.assigns.current_user do
      conn
      |> redirect(to: ~p"/inbox")
    else
      render(conn, :home, layout: false)
    end
  end
end
