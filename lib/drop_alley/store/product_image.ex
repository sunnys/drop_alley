defmodule DropAlley.Store.ProductImage do
  use Arc.Ecto.Schema
  use Ecto.Schema
  import Ecto.Changeset


  schema "product_images" do
    field :image, DropAlley.ProductImageUploader.Type
    field :uuid, :string
    belongs_to :product, DropAlley.Store.Product, foreign_key: :product_id
    timestamps()
  end

  @doc false
  def changeset(product_image, attrs) do
    product_image
    |> cast(attrs, [:product_id, :uuid])
    |> check_uuid
    |> cast_attachments(attrs, [:image], allow_paths: true)
  end

  defp check_uuid(changeset) do
    if get_field(changeset, :uuid) == nil do
      force_change(changeset, :uuid, UUID.uuid1)
    else
      changeset
    end
  end
end
