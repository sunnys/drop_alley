defmodule DropAlley.Store.ProductImage do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "product_images" do
    field :image, DropAlley.ImageUploader.Type
    # field :product_id, :id
    belongs_to :product, DropAlley.Store.Product, foreign_key: :product_id
    timestamps()
  end

  @doc false
  def changeset(product_image, attrs) do
    product_image
    |> cast(attrs, [:image, :product_id])
    |> cast_attachments(attrs, [:image])
  end
end
