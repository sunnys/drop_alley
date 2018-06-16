defmodule DropAlley.Purchase.Cart do
  use Ecto.Schema
  import Ecto.Changeset


  schema "carts" do
    field :active, :boolean, default: false
    field :state, :string
    # field :buyer_id, :id
    belongs_to :buyer, DropAlley.Store.Buyer, foreign_key: :buyer_id
    has_many :products, DropAlley.Store.Product, foreign_key: :product_id
    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:state, :active, :buyer_id])
    |> validate_required([:state, :active])
  end
end
