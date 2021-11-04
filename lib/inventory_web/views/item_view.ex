defmodule InventoryWeb.ItemView do
  use InventoryWeb, :view
  alias InventoryWeb.ItemView

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      sku: item.sku,
      tenant_id: item.tenant_id,
      description: item.description,
      weight: item.weight,
      unit: item.unit
    }
  end
end
