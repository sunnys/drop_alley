defmodule DropAlley.Repo.Migrations.AddSizeInOrder do
  use Ecto.Migration

  def change do
    alter table("orders") do
      add :size, :string
    end
  end
end
