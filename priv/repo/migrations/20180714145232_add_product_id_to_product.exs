defmodule DropAlley.Repo.Migrations.AddProductIdToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :prod_id, :string
      add :discount, :float
      add :brand, :string 
      add :color, :string 
      add :material, :string 
      add :category, :string 
      add :subcategory, :string
      add :stocks, :jsonb, default: "[]"
    end
  end
end
