defmodule InventoryWeb.LineItemControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.ShippingFixtures

  setup %{conn: conn} do
    tenant_id = Ecto.UUID.generate()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("tenant-id", tenant_id)

    {:ok, conn: conn, tenant_id: tenant_id}
  end

  describe "index" do
    test "lists all line_items", %{conn: conn, tenant_id: tenant_id} do
      shipment =
        %{line_items: [%{id: id, unit: unit, quantity: quantity}]} =
        shipment_fixture(%{
          line_items: [%{"quantity" => 1, "unit" => "pl", "tenant_id" => tenant_id}],
          tenant_id: tenant_id
        })

      conn = get(conn, Routes.shipment_line_item_path(conn, :index, shipment.id))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => id,
                 "quantity" => quantity,
                 "unit" => Atom.to_string(unit),
                 "tenant_id" => tenant_id
               }
             ]
    end
  end
end
