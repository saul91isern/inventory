defmodule InventoryWeb.WarehouseControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.WarehousingFixtures

  alias Inventory.Warehousing.Warehouse

  @create_attrs %{
    address: "some address",
    name: "some name",
    tenant_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    address: "some updated address",
    name: "some updated name",
    tenant_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{address: nil, name: nil, tenant_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all warehouses", %{conn: conn} do
      conn = get(conn, Routes.warehouse_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create warehouse" do
    test "renders warehouse when data is valid", %{conn: conn} do
      conn = post(conn, Routes.warehouse_path(conn, :create), warehouse: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.warehouse_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some address",
               "name" => "some name",
               "tenant_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.warehouse_path(conn, :create), warehouse: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update warehouse" do
    setup [:create_warehouse]

    test "renders warehouse when data is valid", %{
      conn: conn,
      warehouse: %Warehouse{id: id} = warehouse
    } do
      conn = put(conn, Routes.warehouse_path(conn, :update, warehouse), warehouse: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.warehouse_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "name" => "some updated name",
               "tenant_id" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, warehouse: warehouse} do
      conn = put(conn, Routes.warehouse_path(conn, :update, warehouse), warehouse: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete warehouse" do
    setup [:create_warehouse]

    test "deletes chosen warehouse", %{conn: conn, warehouse: warehouse} do
      conn = delete(conn, Routes.warehouse_path(conn, :delete, warehouse))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.warehouse_path(conn, :show, warehouse))
      end
    end
  end

  defp create_warehouse(_) do
    warehouse = warehouse_fixture()
    %{warehouse: warehouse}
  end
end
