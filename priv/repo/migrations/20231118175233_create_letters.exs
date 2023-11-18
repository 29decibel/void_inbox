defmodule VoidInbox.Repo.Migrations.CreateLetters do
  use Ecto.Migration

  def change do
    create table(:letters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :raw_message, :map
      add :to_email, :string
      add :from_email, :string
      add :html_content, :text
      add :text_content, :text
      add :subject, :string
      add :read, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:letters, [:user_id])
  end
end
