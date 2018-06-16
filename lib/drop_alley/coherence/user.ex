defmodule DropAlley.Coherence.User do
  @moduledoc false
  use Ecto.Schema
  use Coherence.Schema
  use CoherenceAssent.Schema

  

  schema "users" do
    field :name, :string
    field :email, :string
    coherence_schema()
    coherence_assent_schema()

    has_many :products, DropAlley.Store.Product, foreign_key: :owner_id
    has_many :addresses, DropAlley.UserInformation.Address , foreign_key: :user_id
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields())
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence_assent(params)
  end

  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
  end
end
