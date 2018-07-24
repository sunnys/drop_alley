defmodule DropAlley.Repo.Migrations.AddSizeArrayInProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :sizes, {:array, :string}
    end
  end
end
