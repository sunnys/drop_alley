defmodule DropAlley.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :state, :string
      add :active, :boolean, default: false, null: false
      add :assigned_time, :naive_datetime
      add :pickup_time, :naive_datetime
      add :pick_up_location, :map
      add :drop_time, :naive_datetime
      add :drop_location, :map
      add :partner_id, references(:partners, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:buckets, [:partner_id])
    create index(:buckets, [:product_id])
  end
end
