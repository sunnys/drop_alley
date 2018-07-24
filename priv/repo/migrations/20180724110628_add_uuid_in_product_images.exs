defmodule DropAlley.Repo.Migrations.AddUUIDInProductImages do
  use Ecto.Migration

  def change do
    alter table("product_images") do
      add :uuid, :string 
    end
  end
end
