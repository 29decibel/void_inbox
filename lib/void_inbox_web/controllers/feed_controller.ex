defmodule VoidInboxWeb.FeedController do
  use VoidInboxWeb, :controller

  alias VoidInbox.Feeds

  def show(conn, %{"slug" => slug}) do
    feed = Feeds.get_feed_by_slug(slug)
    # render json
    atom_feed = Feeds.atom_json_feed(feed, url(~p"/feeds/#{slug}"))

    json(conn, atom_feed)
  end
end
