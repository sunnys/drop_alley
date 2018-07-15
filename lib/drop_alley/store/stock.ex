defmodule DropAlley.Store.Stock do
    use Ecto.Schema
    import Ecto.Changeset
    
    @primary_key false
    embedded_schema do
      field :address, :string
      field :stock, :integer
    end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:address, :stock])
      |> validate_required([:address, :stock])
    end
end