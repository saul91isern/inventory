defmodule InventoryWeb.LineItemController do
  use InventoryWeb, :controller

  alias Inventory.Shipping

  action_fallback InventoryWeb.FallbackController

  def index(conn, params) do
    params = list_line_params(params)
    line_items = Shipping.list_line_items(params)
    render(conn, "index.json", line_items: line_items)
  end

  defp list_line_params(params) do
    Enum.reduce(params, %{}, fn
      {"shipment_id", shipment_id}, acc ->
        Map.put(acc, :shipment_id, shipment_id)

      _, acc ->
        acc
    end)
  end
end
