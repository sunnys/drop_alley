defmodule DropAlley.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset


  schema "products" do
    field :description, :string
    field :inspection_process, :map
    field :name, :string
    field :prprice, :float
    field :state, :string
    field :return_code, :string
    
    
    belongs_to :owner, DropAlley.Coherence.User, foreign_key: :owner_id
    belongs_to :retailer, DropAlley.Store.Retailer, foreign_key: :retailer_id
    belongs_to :return_consumer, DropAlley.Store.ReturnConsumer , foreign_key: :return_consumer_id
    belongs_to :order, DropAlley.Purchase.Order, foreign_key: :order_id
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :prprice, :state, :inspection_process, :owner_id, :retailer_id, :return_code, :return_consumer_id, :order_id])
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
