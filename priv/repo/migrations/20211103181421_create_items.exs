defmodule Inventory.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    execute("CREATE TYPE unit_type AS ENUM ('ea', 'ca', 'pl')")

    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sku, :string, null: false
      add :tenant_id, :uuid, primary_key: true
      add :description, :string, null: false
      add :weight, :integer, null: false
      add :unit, :unit_type, null: false

      add :company_id,
          references(:companies,
            on_delete: :nothing,
            type: :binary_id,
            with: [tenant_id: :tenant_id]
          )

      add :warehouse_id,
          references(:warehouses,
            on_delete: :nothing,
            type: :binary_id,
            with: [tenant_id: :tenant_id]
          )

      timestamps()
    end

    create index(:items, [:company_id])
    create index(:items, [:warehouse_id])
    create unique_index(:items, [:sku])
    create unique_index(:items, [:id, :tenant_id])
  end
end
