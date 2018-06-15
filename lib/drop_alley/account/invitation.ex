defmodule DropAlley.Account.Invitation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "invitations" do
    field :email, :string
    field :name, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:name, :email, :token])
    |> validate_required([:name, :email, :token])
  end
end
