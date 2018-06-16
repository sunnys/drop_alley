defmodule DropAlley.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners) do
      add :name, :string
      add :active, :boolean, default: false, null: false
      add :verified, :boolean, default: false, null: false
      add :contact_no, :string
      add :address, :string
      add :current_location, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:partners, [:user_id])
  end
end
