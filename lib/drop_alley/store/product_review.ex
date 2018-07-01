defmodule DropAlley.Store.ProductReview do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "product_reviews" do
    field :image, DropAlley.ImageUploader.Type
    field :name, :string
    field :rating, :integer
    field :comment, :string
    # field :product_id, :id
    belongs_to :product, DropAlley.Store.Product, foreign_key: :product_id

    timestamps()
  end

  @doc false
  def changeset(product_review, attrs) do
    product_review
    |> cast(attrs, [:name, :rating, :comment])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:name, :rating])
  end
end
