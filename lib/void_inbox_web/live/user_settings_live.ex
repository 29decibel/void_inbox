defmodule VoidInboxWeb.UserSettingsLive do
  use VoidInboxWeb, :live_view

  alias VoidInbox.Accounts
  alias VoidInbox.Feeds

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    # void email
    void_email_changeset =
      VoidInbox.VoidEmails.change_void_email(%VoidInbox.VoidEmails.VoidEmail{})

    void_emails = VoidInbox.VoidEmails.list_void_emails(user.id)

    # rss feed
    rss_feeds = Feeds.list_feeds(user.id)

    feed_form =
      Feeds.change_feed(%Feeds.Feed{}, %{
        slug: RandomStringGenerator.random_friendly_string(),
        user_id: user.id
      })

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:void_email_form, to_form(void_email_changeset))
      |> assign(:void_emails, void_emails)
      |> assign(:rss_feeds, rss_feeds)
      |> assign(:feed_form, feed_form)
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("create_void_email", %{"void_email" => params}, socket) do
    params = Map.put(params, "user_id", socket.assigns.current_user.id)

    case VoidInbox.VoidEmails.create_void_email(params) do
      {:ok, void_email} ->
        # append to existing one
        void_emails = socket.assigns.void_emails ++ [void_email]
        {:noreply, assign(socket, void_emails: void_emails)}

      {:error, changeset} ->
        {:noreply, assign(socket, void_email_form: to_form(changeset))}
    end
  end

  def handle_event("delete-void-email", %{"id" => id}, socket) do
    void_email = VoidInbox.VoidEmails.get_void_email!(id)
    VoidInbox.VoidEmails.delete_void_email(void_email)
    # remove from current void_emails
    void_emails = Enum.filter(socket.assigns.void_emails, fn v -> v.id != id end)
    {:noreply, assign(socket, void_emails: void_emails)}
  end

  def handle_event("create_feed", %{}, socket) do
    {:ok, feed} = Feeds.create_feed_for_user(socket.assigns.current_user.id)
    # add feed to existing feeds
    feeds = socket.assigns.rss_feeds ++ [feed]
    {:noreply, assign(socket, rss_feeds: feeds)}
  end

  def handle_event("delete-rss-feed", %{"id" => id, "value" => ""}, socket) do
    feed = Feeds.get_feed!(id)
    Feeds.delete_feed(feed)
    # remove from current rss_feeds
    rss_feeds = Enum.filter(socket.assigns.rss_feeds, fn v -> v.id != id end)
    {:noreply, assign(socket, rss_feeds: rss_feeds)}
  end
end
