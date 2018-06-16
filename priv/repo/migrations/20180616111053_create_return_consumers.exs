defmodule DropAlley.Repo.Migrations.CreateReturnConsumers do
  use Ecto.Migration

  def change do
    create table(:return_consumers) do
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:return_consumers, [:user_id])
  end
end
