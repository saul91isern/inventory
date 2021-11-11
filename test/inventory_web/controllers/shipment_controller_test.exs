defmodule InventoryWeb.ShipmentControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.ShippingFixtures

  alias Inventory.Shipping.Shipment

  @create_attrs %{
    carrier: "some carrier",
    estimated_delivery_date: ~U[2021-11-10 12:45:00.000000Z],
    ship_date: ~U[2021-11-10 12:45:00.000000Z],
    tenant_id: "7488a646-e31f-11e4-aace-600308960662",
    tracking_number: "some tracking_number"
  }
  @update_attrs %{
    carrier: "some updated carrier",
    estimated_delivery_date: ~U[2021-11-11 12:45:00.000000Z],
    ship_date: ~U[2021-11-11 12:45:00.000000Z],
    tenant_id: "7488a646-e31f-11e4-aace-600308960668",
    tracking_number: "some updated tracking_number"
  }
  @invalid_attrs %{
    carrier: nil,
    estimated_delivery_date: nil,
    ship_date: nil,
    tenant_id: nil,
    tracking_number: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shipments", %{conn: conn} do
      conn = get(conn, Routes.shipment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shipment" do
    test "renders shipment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.shipment_path(conn, :create), shipment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.shipment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "carrier" => "some carrier",
               "estimated_delivery_date" => "2021-11-10T12:45:00.000000Z",
               "ship_date" => "2021-11-10T12:45:00.000000Z",
               "tenant_id" => "7488a646-e31f-11e4-aace-600308960662",
               "tracking_number" => "some tracking_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.shipment_path(conn, :create), shipment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shipment" do
    setup [:create_shipment]

    test "renders shipment when data is valid", %{
      conn: conn,
      shipment: %Shipment{id: id} = shipment
    } do
      conn = put(conn, Routes.shipment_path(conn, :update, shipment), shipment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.shipment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "carrier" => "some updated carrier",
               "estimated_delivery_date" => "2021-11-11T12:45:00.000000Z",
               "ship_date" => "2021-11-11T12:45:00.000000Z",
               "tenant_id" => "7488a646-e31f-11e4-aace-600308960668",
               "tracking_number" => "some updated tracking_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shipment: shipment} do
      conn = put(conn, Routes.shipment_path(conn, :update, shipment), shipment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shipment" do
    setup [:create_shipment]

    test "deletes chosen shipment", %{conn: conn, shipment: shipment} do
      conn = delete(conn, Routes.shipment_path(conn, :delete, shipment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.shipment_path(conn, :show, shipment))
      end
    end
  end

  defp create_shipment(_) do
    shipment = shipment_fixture()
    %{shipment: shipment}
  end
end
