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

    shipment
  end
end
