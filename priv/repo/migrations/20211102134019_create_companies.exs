defmodule Inventory.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :tenant_id, :uuid, primary_key: true

      timestamps()
    end

    create unique_index(:companies, [:id, :tenant_id])
  end
end
