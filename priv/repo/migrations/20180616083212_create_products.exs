defmodule DropAlley.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :prprice, :float
      add :state, :string
      add :inspection_process, :map
      add :owner_id, :integer
      add :owner, references(:users, on_delete: :nothing)
      timestamps()
    end

  end
end
