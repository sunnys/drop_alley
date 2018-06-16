defmodule DropAlley.UserInformation.Address do
  use Ecto.Schema
  import Ecto.Changeset


  schema "addresses" do
    field :active, :boolean, default: false
    field :addr, :string
    field :city, :string
    field :contact_no, :string
    field :pincode, :string
    field :state, :string
    field :street, :string
    belongs_to :user, DropAlley.Coherence.User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:active, :addr, :street, :city, :state, :pincode, :contact_no, :user_id])
    |> validate_required([:active, :addr, :street, :city, :state, :pincode, :contact_no])
  end
end
