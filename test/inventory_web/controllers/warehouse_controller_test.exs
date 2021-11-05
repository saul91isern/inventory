defmodule InventoryWeb.WarehouseControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.WarehousingFixtures

  alias Inventory.Warehousing.Warehouse

  @create_attrs %{
    address: "some address",
    name: "some name"
  }
  @update_attrs %{
    address: "some updated address",
    name: "some updated name"
  }
  @invalid_attrs %{address: nil, name: nil, tenant_id: nil}

  setup %{conn: conn} do
    tenant_id = Ecto.UUID.generate()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("tenant-id", tenant_id)

    {:ok, conn: conn, tenant_id: tenant_id}
  end

  describe "index" do
    test "lists all warehouses", %{conn: conn} do
      conn = get(conn, Routes.warehouse_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create warehouse" do
    test "renders warehouse when data is valid", %{conn: conn, tenant_id: tenant_id} do
      company = company_fixture(%{tenant_id: tenant_id})
      create_attrs = Map.put(@create_attrs, :company_id, company.id)
      conn = post(conn, Routes.warehouse_path(conn, :create), data: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.warehouse_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some address",
               "name" => "some name",
               "tenant_id" => ^tenant_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tenant_id: tenant_id} do
      company = company_fixture(%{tenant_id: tenant_id})
      invalid_attrs = Map.put(@invalid_attrs, :company_id, company.id)
      conn = post(conn, Routes.warehouse_path(conn, :create), data: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update warehouse" do
    setup [:create_warehouse]

    test "renders warehouse when data is valid", %{
      conn: conn,
      warehouse: %Warehouse{id: id} = warehouse,
      tenant_id: tenant_id
    } do
      conn = put(conn, Routes.warehouse_path(conn, :update, warehouse), data: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.warehouse_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "name" => "some updated name",
               "tenant_id" => ^tenant_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, warehouse: warehouse} do
      conn = put(conn, Routes.warehouse_path(conn, :update, warehouse), data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete warehouse" do
    setup [:create_warehouse]

    test "deletes chosen warehouse", %{conn: conn, warehouse: warehouse, tenant_id: tenant_id} do
      conn = delete(conn, Routes.warehouse_path(conn, :delete, warehouse))
      assert response(conn, 204)

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.warehouse_path(conn, :show, warehouse))
      end
    end
  end

  defp create_warehouse(assigns) do
    attrs = %{tenant_id: assigns[:tenant_id]}

    warehouse = warehouse_fixture(attrs)
    %{warehouse: warehouse}
  end
end
