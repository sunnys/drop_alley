defmodule DropAlley.ChannelPartner.Partner do
  use Ecto.Schema
  import Ecto.Changeset


  schema "partners" do
    field :active, :boolean, default: false
    field :address, :string
    field :contact_no, :string
    field :current_location, :map
    field :name, :string
    field :verified, :boolean, default: false
    # field :user_id, :id
    belongs_to :user, DropAlley.Coherence.User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:name, :active, :verified, :contact_no, :address, :current_location, :user_id])
    |> validate_required([:name, :active, :verified, :contact_no, :address])
  end
end
