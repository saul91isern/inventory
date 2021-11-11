defmodule Inventory.ShippingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Inventory.Shipping` context.
  """

  alias Inventory.WarehousingFixtures

  @doc """
  Generate a shipment.
  """
  def shipment_fixture(attrs \\ %{}) do
    tenant_id = Ecto.UUID.generate()

    ext_attrs =
      attrs
      |> Map.take([:tenant_id])
      |> Enum.into(%{
        tenant_id: tenant_id
      })

    company = WarehousingFixtures.company_fixture(ext_attrs)

    {:ok, shipment} =
      attrs
      |> Enum.into(%{
        carrier: "some carrier",
        estimated_delivery_date: ~U[2021-11-10 12:45:00.000000Z],
        ship_date: ~U[2021-11-10 12:45:00.000000Z],
        tenant_id: tenant_id,
        tracking_number: "some tracking_number"
      })
      |> Inventory.Shipping.create_shipment(company)

    Inventory.Repo.put_tenant_id(shipment.tenant_id)

    shipment
  end

  @doc """
  Generate a line_item.
  """
  def line_item_fixture(attrs \\ %{}) do
    tenant_id = Ecto.UUID.generate()

    {:ok, line_item} =
      attrs
      |> Enum.into(%{
        quantity: 42,
        tenant_id: tenant_id,
        unit: "some unit"
      })
      |> Inventory.Shipping.create_line_item()

    Inventory.Repo.put_tenant_id(line_item.tenant_id)

    line_item
  end
end
