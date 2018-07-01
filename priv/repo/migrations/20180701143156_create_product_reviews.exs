defmodule DropAlley.Repo.Migrations.CreateProductReviews do
  use Ecto.Migration

  def change do
    create table(:product_reviews) do
      add :name, :string
      add :rating, :integer
      add :image, :string
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:product_reviews, [:product_id])
  end
end
