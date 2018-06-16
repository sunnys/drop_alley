defmodule DropAlley.Repo.Migrations.CreateBuyers do
  use Ecto.Migration

  def change do
    create table(:buyers) do
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:buyers, [:user_id])
  end
end
