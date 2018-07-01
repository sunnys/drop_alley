defmodule DropAlley.Repo.Migrations.AddColumnDetailsToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :detail, :map
      add :size, :string
      add :availability, :boolean
      add :price, :float
    end
  end
end
