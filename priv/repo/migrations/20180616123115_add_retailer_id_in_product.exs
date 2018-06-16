defmodule DropAlley.Repo.Migrations.AddRetailerIdInProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :retailer_id, references(:retailers, on_delete: :nothing)
      add :return_consumer_id, references(:return_consumers, on_delete: :nothing)
      add :return_code, :string
    end
  end
end
