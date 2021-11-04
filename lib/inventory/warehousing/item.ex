defmodule Inventory.Warehousing.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inventory.Warehousing.{Company, Warehouse}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :description, :string
    field :sku, :string
    field :tenant_id, Ecto.UUID
    field :unit, Ecto.Enum, values: [:ea, :ca, :pl]
    field :weight, :integer
    belongs_to :company, Company
    belongs_to :warehouse, Warehouse

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:sku, :tenant_id, :description, :weight, :unit])
    |> validate_required([:sku, :tenant_id, :description, :weight, :unit])
  end
end
