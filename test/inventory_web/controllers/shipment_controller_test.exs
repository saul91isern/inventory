defmodule InventoryWeb.ShipmentControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.ShippingFixtures
  import Inventory.WarehousingFixtures

  alias Inventory.Shipping.Shipment

  @create_attrs %{
    carrier: "some carrier",
    estimated_delivery_date: ~U[2021-11-10 12:45:00.000000Z],
    ship_date: ~U[2021-11-10 12:45:00.000000Z],
    tracking_number: "some tracking_number"
  }
  @update_attrs %{
    carrier: "some updated carrier",
    estimated_delivery_date: ~U[2021-11-11 12:45:00.000000Z],
    ship_date: ~U[2021-11-11 12:45:00.000000Z],
    tracking_number: "some updated tracking_number"
  }
  @invalid_attrs %{
    carrier: nil,
    estimated_delivery_date: nil,
    ship_date: nil,
    tracking_number: nil
  }

  setup %{conn: conn} do
    tenant_id = Ecto.UUID.generate()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("tenant-id", tenant_id)

    {:ok, conn: conn, tenant_id: tenant_id}
  end

  describe "index" do
    test "lists all shipments", %{conn: conn} do
      conn = get(conn, Routes.shipment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all shipments filtered by company id", %{conn: conn, tenant_id: tenant_id} do
      shipment = shipment_fixture(%{tenant_id: tenant_id})

      conn = get(conn, Routes.company_shipment_path(conn, :index, shipment.company_id))

      assert json_response(conn, 200)["data"] == [
               %{
                 "carrier" => shipment.carrier,
                 "estimated_delivery_date" =>
                   DateTime.to_iso8601(shipment.estimated_delivery_date),
                 "id" => shipment.id,
                 "ship_date" => DateTime.to_iso8601(shipment.ship_date),
                 "tenant_id" => tenant_id,
                 "tracking_number" => shipment.tracking_number
               }
             ]
    end
  end

  describe "create shipment" do
    test "renders shipment when data is valid", %{conn: conn, tenant_id: tenant_id} do
      company = company_fixture(%{tenant_id: tenant_id})

      conn =
        post(conn, Routes.company_shipment_path(conn, :create, company.id), data: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.shipment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "carrier" => "some carrier",
               "estimated_delivery_date" => "2021-11-10T12:45:00.000000Z",
               "ship_date" => "2021-11-10T12:45:00.000000Z",
               "tenant_id" => ^tenant_id,
               "tracking_number" => "some tracking_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tenant_id: tenant_id} do
      company = company_fixture(%{tenant_id: tenant_id})

      conn =
        post(conn, Routes.company_shipment_path(conn, :create, company.id), data: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shipment" do
    setup [:create_shipment]

    test "renders shipment when data is valid", %{
      conn: conn,
      shipment: %Shipment{id: id} = shipment,
      tenant_id: tenant_id
    } do
      conn = put(conn, Routes.shipment_path(conn, :update, shipment), data: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.shipment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "carrier" => "some updated carrier",
               "estimated_delivery_date" => "2021-11-11T12:45:00.000000Z",
               "ship_date" => "2021-11-11T12:45:00.000000Z",
               "tracking_number" => "some updated tracking_number",
               "tenant_id" => ^tenant_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shipment: shipment} do
      conn = put(conn, Routes.shipment_path(conn, :update, shipment), data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shipment" do
    setup [:create_shipment]

    test "deletes chosen shipment", %{conn: conn, shipment: shipment, tenant_id: tenant_id} do
      conn = delete(conn, Routes.shipment_path(conn, :delete, shipment))
      assert response(conn, 204)
      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.shipment_path(conn, :show, shipment))
      end
    end
  end

  defp create_shipment(assigns) do
    attrs = %{tenant_id: assigns[:tenant_id]}

    shipment = shipment_fixture(attrs)
    %{shipment: shipment}
  end
end
