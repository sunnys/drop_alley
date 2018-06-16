defmodule DropAlley.Store.Buyer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "buyers" do
    field :active, :boolean, default: false

    belongs_to :user, DropAlley.Coherence.User, foreign_key: :user_id
    has_many :orders, DropAlley.Purchase.Order, foreign_key: :buyer_id
    timestamps()
  end

  @doc false
  def changeset(buyer, attrs) do
    buyer
    |> cast(attrs, [:active, :user_id])
    |> validate_required([:active, :user_id])
  end
end
