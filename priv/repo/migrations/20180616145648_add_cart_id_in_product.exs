defmodule DropAlley.Repo.Migrations.AddCartIdInProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :cart_id, references(:orders, on_delete: :nothing)
    end
  end
end
