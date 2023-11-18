defmodule VoidInbox.VoidEmails.VoidEmail do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "void_emails" do
    field :name, :string
    field :status, Ecto.Enum, values: [:active, :inactive], default: :active

    belongs_to :user, VoidInbox.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(void_email, attrs) do
    void_email
    |> cast(attrs, [:name, :status, :user_id])
    |> validate_required([:name, :status, :user_id])
    |> unique_constraint(:name)
  end
end
