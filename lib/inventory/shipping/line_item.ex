defmodule Inventory.Shipping.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Inventory.Shipping.Shipment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "line_items" do
    field :quantity, :integer
    field :tenant_id, Ecto.UUID
    field :unit, :string
    field :item_id, :binary_id
    belongs_to :shipment, Shipment

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:tenant_id, :quantity, :unit])
    |> validate_required([:tenant_id, :quantity, :unit])
  end
end
