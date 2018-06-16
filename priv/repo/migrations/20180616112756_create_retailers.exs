defmodule DropAlley.Repo.Migrations.CreateRetailers do
  use Ecto.Migration

  def change do
    create table(:retailers) do
      add :name, :string
      add :api_key, :string
      add :details, :map
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:retailers, [:user_id])
  end
end
