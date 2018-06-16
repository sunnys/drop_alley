defmodule DropAlley.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :active, :boolean, default: false, null: false
      add :addr, :string
      add :street, :string
      add :city, :string
      add :state, :string
      add :pincode, :string
      add :contact_no, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:addresses, [:user_id])
  end
end
