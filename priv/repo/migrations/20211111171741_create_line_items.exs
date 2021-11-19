defmodule Inventory.Repo.Migrations.CreateLineItems do
  use Ecto.Migration

  def change do
    create table(:line_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tenant_id, :uuid, primary_key: true
      add :quantity, :integer, null: false
      add :unit, :unit_type, null: false

      add :shipment_id,
          references(:shipments,
            on_delete: :nothing,
            type: :binary_id,
            with: [tenant_id: :tenant_id]
          )

      add :item_id,
          references(:items, on_delete: :nothing, type: :binary_id, with: [tenant_id: :tenant_id])

      timestamps()
    end

    create index(:line_items, [:shipment_id])
    create index(:line_items, [:item_id])
    create unique_index(:line_items, [:id, :tenant_id])
  end
end
