defmodule DropAlley.Account.UserIdentity do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user_identities" do
    field :provider, :string
    field :uid, :string
    field :user_id, :integer
  end

  @doc false
  def changeset(user_identity, attrs) do
    user_identity
    |> cast(attrs, [:user_id, :provider, :uid])
    |> validate_required([:user_id, :provider, :uid])
  end
end
