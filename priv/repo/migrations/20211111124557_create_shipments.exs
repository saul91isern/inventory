defmodule Inventory.Repo.Migrations.CreateShipments do
  use Ecto.Migration

  def change do
    create table(:shipments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tenant_id, :uuid, primary_key: true
      add :ship_date, :utc_datetime_usec, null: false
      add :estimated_delivery_date, :utc_datetime_usec, null: false
      add :carrier, :string, null: false
      add :tracking_number, :string, null: false

      add :company_id,
          references(:companies,
            on_delete: :nothing,
            type: :binary_id,
            with: [tenant_id: :tenant_id]
          ),
          null: false

      timestamps()
    end

    create index(:shipments, [:company_id])
    create unique_index(:shipments, [:id, :tenant_id])
  end
end
