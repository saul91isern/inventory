defmodule Inventory.Warehousing.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
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

  def put_company(%Changeset{valid?: true} = changeset, %Company{} = company) do
    put_assoc(changeset, :company, company)
  end

  def put_company(changeset, _company), do: changeset

  def put_warehouse(%Changeset{valid?: true} = changeset, %Warehouse{} = warehouse) do
    put_assoc(changeset, :warehouse, warehouse)
  end

  def put_warehouse(changeset, _warehouse), do: changeset
end
