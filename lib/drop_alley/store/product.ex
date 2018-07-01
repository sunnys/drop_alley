defmodule DropAlley.Store.Product do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "products" do
    field :description, :string
    field :inspection_process, :map
    field :name, :string
    field :prprice, :float
    field :state, :string
    field :return_code, :string
    field :image, DropAlley.ImageUploader.Type
    
    
    belongs_to :owner, DropAlley.Coherence.User, foreign_key: :owner_id
    belongs_to :retailer, DropAlley.Store.Retailer, foreign_key: :retailer_id
    belongs_to :return_consumer, DropAlley.Store.ReturnConsumer , foreign_key: :return_consumer_id
    belongs_to :order, DropAlley.Purchase.Order, foreign_key: :order_id
    belongs_to :cart, DropAlley.Purchase.Order, foreign_key: :cart_id
    
    many_to_many :selling_partners, DropAlley.ChannelPartner.Partner , join_through: "buckets"
    has_many :product_images, DropAlley.Store.ProductImage
    has_many :product_reviews, DropAlley.Store.ProductReview

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :prprice, :state, :inspection_process, :owner_id, :retailer_id, :return_code, :return_consumer_id, :order_id, :cart_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:name, :description, :prprice, :state, :retailer_id])
    |> put_return_code
  end

  defp put_return_code(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{}} ->
        put_change(changeset, :return_code, UUID.uuid1())
      _ ->
        changeset
    end
  end
end
