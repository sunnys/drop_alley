defmodule DropAlley.Store.Retailer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "retailers" do
    field :active, :boolean, default: false
    field :api_key, :string
    field :details, :map
    field :name, :string
    # field :user_id, :id
    belongs_to :user, DropAlley.Coherence.User, foreign_key: :user_id
    has_many :products, DropAlley.Store.Product, foreign_key: :retailer_id
    timestamps()
  end

  @doc false
  def changeset(retailer, attrs) do
    retailer
    |> cast(attrs, [:name, :api_key, :details, :active, :user_id, :retailer_id])
    |> validate_required([:name, :api_key, :active])
  end
end
