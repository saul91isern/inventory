defmodule Inventory.Shipping.Shipment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Inventory.Warehousing.Company

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "shipments" do
    field :carrier, :string
    field :estimated_delivery_date, :utc_datetime_usec
    field :ship_date, :utc_datetime_usec
    field :tenant_id, Ecto.UUID
    field :tracking_number, :string
    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(shipment, attrs) do
    shipment
    |> cast(attrs, [:tenant_id, :ship_date, :estimated_delivery_date, :carrier, :tracking_number])
    |> validate_required([
      :tenant_id,
      :ship_date,
      :estimated_delivery_date,
      :carrier,
      :tracking_number
    ])
  end

  def put_company(%Changeset{valid?: true} = changeset, %Company{} = company) do
    put_assoc(changeset, :company, company)
  end

  def put_company(changeset, _company), do: changeset
end
