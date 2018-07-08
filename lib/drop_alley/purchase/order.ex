defmodule DropAlley.Purchase.Order do
  use Ecto.Schema
  import Ecto.Changeset


  schema "orders" do
    field :active, :boolean, default: false
    field :paid, :boolean, default: false
    field :payment_type, :string
    field :purchase, :boolean, default: false
    field :state, :string
    field :trial, :boolean, default: false
    # field :product_id, :id
    belongs_to :buyer , DropAlley.Store.Buyer, foreign_key: :buyer_id
    has_many :products, DropAlley.Store.Product, foreign_key: :order_id
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state, :active, :trial, :purchase, :payment_type, :paid, :buyer_id])
    |> validate_required([:state, :active, :trial, :purchase, :payment_type, :paid])
  end
end
