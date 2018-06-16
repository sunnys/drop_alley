defmodule DropAlley.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :state, :string
      add :active, :boolean, default: false, null: false
      add :trial, :boolean, default: false, null: false
      add :purchase, :boolean, default: false, null: false
      add :payment_type, :string
      add :paid, :boolean, default: false, null: false
      add :buyer_id, references(:buyers, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:buyer_id])
  end
end
