defmodule VoidInbox.Repo.Migrations.CreateVoidEmails do
  use Ecto.Migration

  def change do
    create table(:void_emails, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:void_emails, [:name])
    create index(:void_emails, [:user_id])
  end
end
