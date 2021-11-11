defmodule InventoryWeb.ShipmentView do
  use InventoryWeb, :view
  alias InventoryWeb.ShipmentView

  def render("index.json", %{shipments: shipments}) do
    %{data: render_many(shipments, ShipmentView, "shipment.json")}
  end

  def render("show.json", %{shipment: shipment}) do
    %{data: render_one(shipment, ShipmentView, "shipment.json")}
  end

  def render("shipment.json", %{shipment: shipment}) do
    %{
      id: shipment.id,
      tenant_id: shipment.tenant_id,
      ship_date: shipment.ship_date,
      estimated_delivery_date: shipment.estimated_delivery_date,
      carrier: shipment.carrier,
      tracking_number: shipment.tracking_number
    }
  end
end
