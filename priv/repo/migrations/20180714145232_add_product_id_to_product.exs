defmodule DropAlley.Repo.Migrations.AddProductIdToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :prod_id, :string
      add :discount, :float
      add :stocks, :jsonb, default: "[]"
    end
  end
end
