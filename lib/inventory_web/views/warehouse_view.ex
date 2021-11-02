defmodule InventoryWeb.WarehouseView do
  use InventoryWeb, :view
  alias InventoryWeb.WarehouseView

  def render("index.json", %{warehouses: warehouses}) do
    %{data: render_many(warehouses, WarehouseView, "warehouse.json")}
  end

  def render("show.json", %{warehouse: warehouse}) do
    %{data: render_one(warehouse, WarehouseView, "warehouse.json")}
  end

  def render("warehouse.json", %{warehouse: warehouse}) do
    %{
      id: warehouse.id,
      name: warehouse.name,
      address: warehouse.address,
      tenant_id: warehouse.tenant_id
    }
  end
end
