defmodule VoidInbox.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :slug, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:feeds, [:slug])
    create index(:feeds, [:user_id])
  end
end
