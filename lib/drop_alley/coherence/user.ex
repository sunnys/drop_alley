defmodule DropAlley.Coherence.User do
  @moduledoc false
  use Ecto.Schema
  # use Coherence.Schema
  # use CoherenceAssent.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema#,
    # extensions: [PowEmailConfirmation, PowResetPassword],
    # password_hash_methods: {&Comeonin.Bcrypt.hashpwsalt/1,
                            # &Comeonin.Bcrypt.checkpw/2}

  

  schema "users" do
    field :name, :string
    field :email, :string
    # coherence_schema()
    # coherence_assent_schema()
    pow_user_fields()
    has_many :products, DropAlley.Store.Product, foreign_key: :owner_id
    has_many :addresses, DropAlley.UserInformation.Address , foreign_key: :user_id
    timestamps()
  end

  # @spec changeset(t(), map()) :: Changeset.t()
  def changeset(model, params \\ %{}) do
    model
    # |> cast(params, [:name, :email])
    |> pow_changeset(params)
    |> pow_extension_changeset(params)
  end

  # def changeset(model, params \\ %{}) do
  #   model
  #   |> cast(params, [:name, :email])
  #   |> validate_required([:name, :email])
  #   |> validate_format(:email, ~r/@/)
  #   |> unique_constraint(:email)
  #   # |> validate_coherence_assent(params)
  # end

  # def changeset(model, params, :password) do
  #   model
  #   |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
  #   # |> validate_coherence_password_reset(params)
  # end
end
