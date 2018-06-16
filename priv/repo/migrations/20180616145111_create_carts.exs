defmodule DropAlley.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :state, :string
      add :active, :boolean, default: false, null: false
      add :buyer_id, references(:buyers, on_delete: :nothing)

      timestamps()
    end

    create index(:carts, [:buyer_id])
  end
end
