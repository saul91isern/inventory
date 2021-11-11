defmodule InventoryWeb.LineItemControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.ShippingFixtures

  alias Inventory.Shipping.LineItem

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all line_items", %{conn: conn} do
      conn = get(conn, Routes.shipment_line_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
