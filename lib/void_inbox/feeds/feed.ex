defmodule VoidInbox.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feeds" do
    field :slug, :string

    belongs_to :user, VoidInbox.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:slug, :user_id])
    |> validate_required([:slug, :user_id])
    |> unique_constraint(:slug)
  end
end
