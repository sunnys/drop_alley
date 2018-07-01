defmodule DropAlley.Repo.Migrations.AddColumnImageToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :image, :string
    end
  end
end
