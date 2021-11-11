defmodule Inventory.Warehousing.Company do
  use Ecto.Schema
  import Ecto.Changeset

  alias Inventory.Shipping.Shipment
  alias Inventory.Warehousing.{Item, Warehouse}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :tenant_id, Ecto.UUID
    has_many :warehouses, Warehouse
    has_many :items, Item
    has_many :shipments, Shipment

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :tenant_id])
    |> validate_required([:name, :tenant_id])
  end
end
