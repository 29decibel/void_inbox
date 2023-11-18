defmodule VoidInbox.Letters.Letter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "letters" do
    field :read, :boolean, default: false
    field :raw_message, :map
    field :to_email, :string
    field :from_email, :string
    field :html_content, :string
    field :text_content, :string
    field :subject, :string

    belongs_to :user, VoidInbox.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(letter, attrs) do
    letter
    |> cast(attrs, [
      :raw_message,
      :to_email,
      :from_email,
      :html_content,
      :text_content,
      :subject,
      :read,
      :user_id
    ])
    |> validate_required([
      :to_email,
      :from_email,
      :subject,
      :read,
      :user_id
    ])
  end
end
