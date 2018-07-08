defmodule DropAlley.Repo.Migrations.AddColumnCountryInAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :country, :string
    end
  end
end
