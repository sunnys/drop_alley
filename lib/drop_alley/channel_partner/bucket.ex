defmodule DropAlley.ChannelPartner.Bucket do
  use Ecto.Schema
  import Ecto.Changeset


  schema "buckets" do
    field :active, :boolean, default: false
    field :assigned_time, :naive_datetime
    field :drop_location, :map
    field :drop_time, :naive_datetime
    field :pick_up_location, :map
    field :pickup_time, :naive_datetime
    field :state, :string
    
    belongs_to :partner, DropAlley.ChannelPartner.Partner, foreign_key: :partner_id
    belongs_to :product, DropAlley.Store.Product, foreign_key: :product_id

    timestamps()
  end

  @doc false
  def changeset(bucket, attrs) do
    bucket
    |> cast(attrs, [:state, :active, :assigned_time, :pickup_time, :pick_up_location, :drop_time, :drop_location, :partner_id, :product_id])
    |> validate_required([:state, :active, :assigned_time, :pickup_time, :drop_time])
  end
end
