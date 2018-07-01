defmodule DropAlley.Repo.Migrations.AddCommentToProductReview do
  use Ecto.Migration

  def change do
    alter table(:product_reviews) do
      add :comment, :string
    end
  end
end
