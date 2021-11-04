defmodule Inventory.Warehousing.Warehouse do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inventory.Warehousing.{Company, Item}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "warehouses" do
    field :address, :string
    field :name, :string
    field :tenant_id, Ecto.UUID
    belongs_to :company, Company
    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(warehouse, attrs) do
    warehouse
    |> cast(attrs, [:name, :address, :tenant_id])
    |> validate_required([:name, :address, :tenant_id])
    |> unique_constraint(:address)
  end
end
