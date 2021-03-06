defmodule DropAlley.Repo.Migrations.AddOrderIdInProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :order_id, references(:orders, on_delete: :nothing)
    end
  end
end
