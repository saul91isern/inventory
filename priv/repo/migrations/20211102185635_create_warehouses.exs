defmodule Inventory.Repo.Migrations.CreateWarehouses do
  use Ecto.Migration

  def change do
    create table(:warehouses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :address, :string, null: false
      add :tenant_id, :uuid, primary_key: true

      add :company_id,
          references(:companies,
            on_delete: :nothing,
            type: :binary_id,
            with: [tenant_id: :tenant_id]
          )

      timestamps()
    end

    create index(:warehouses, [:company_id])
    create unique_index(:warehouses, [:address])
    create unique_index(:warehouses, [:id, :tenant_id])
  end
end
