defmodule DropAlley.Store.ReturnConsumer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "return_consumers" do
    field :active, :boolean, default: false
    # field :user_id, :id
    belongs_to :user, DropAlley.Coherence.User, foreign_key: :user_id
    has_many :return_products, DropAlley.Store.Product, foreign_key: :return_consumer_id
    timestamps()
  end

  @doc false
  def changeset(return_consumer, attrs) do
    return_consumer
    |> cast(attrs, [:active])
    |> validate_required([:active])
  end
end
