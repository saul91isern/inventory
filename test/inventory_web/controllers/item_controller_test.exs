defmodule InventoryWeb.ItemControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.WarehousingFixtures

  alias Inventory.Warehousing.Item

  @create_attrs %{
    description: "some description",
    sku: "some sku",
    unit: "ea",
    weight: 42
  }
  @update_attrs %{
    description: "some updated description",
    sku: "some updated sku",
    unit: "pl",
    weight: 43
  }
  @invalid_attrs %{description: nil, sku: nil, tenant_id: nil, unit: nil, weight: nil}

  setup %{conn: conn} do
    tenant_id = Ecto.UUID.generate()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("tenant-id", tenant_id)

    {:ok, conn: conn, tenant_id: tenant_id}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all items filtered by company id and sku", %{conn: conn, tenant_id: tenant_id} do
      item = item_fixture(%{tenant_id: tenant_id})
      company_id = item.company_id
      sku = item.sku

      conn =
        get(conn, Routes.item_path(conn, :index, company_id: company_id, filter: %{sku: sku}))

      assert json_response(conn, 200)["data"] == [
               %{
                 "description" => item.description,
                 "id" => item.id,
                 "sku" => item.sku,
                 "tenant_id" => tenant_id,
                 "unit" => Atom.to_string(item.unit),
                 "weight" => item.weight
               }
             ]
    end

    test "lists all items filtered by warehouse_id", %{conn: conn, tenant_id: tenant_id} do
      item = item_fixture(%{tenant_id: tenant_id})
      warehouse_id = item.warehouse_id

      conn = get(conn, Routes.warehouse_item_path(conn, :index, warehouse_id))

      assert json_response(conn, 200)["data"] == [
               %{
                 "description" => item.description,
                 "id" => item.id,
                 "sku" => item.sku,
                 "tenant_id" => tenant_id,
                 "unit" => Atom.to_string(item.unit),
                 "weight" => item.weight
               }
             ]
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{
      conn: conn,
      tenant_id: tenant_id
    } do
      company = company_fixture(%{tenant_id: tenant_id})
      warehouse = warehouse_fixture(%{tenant_id: tenant_id})

      conn =
        post(conn, Routes.company_warehouse_item_path(conn, :create, company.id, warehouse.id),
          data: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.item_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "sku" => "some sku",
               "tenant_id" => ^tenant_id,
               "unit" => "ea",
               "weight" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tenant_id: tenant_id} do
      company = company_fixture(%{tenant_id: tenant_id})
      warehouse = warehouse_fixture(%{tenant_id: tenant_id})

      conn =
        post(conn, Routes.company_warehouse_item_path(conn, :create, company.id, warehouse.id),
          data: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{
      conn: conn,
      item: %Item{id: id} = item,
      tenant_id: tenant_id
    } do
      conn = put(conn, Routes.item_path(conn, :update, item), data: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.item_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "sku" => "some updated sku",
               "unit" => "pl",
               "weight" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, Routes.item_path(conn, :update, item), data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item, tenant_id: tenant_id} do
      conn = delete(conn, Routes.item_path(conn, :delete, item))
      assert response(conn, 204)
      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.item_path(conn, :show, item))
      end
    end
  end

  defp create_item(assigns) do
    attrs = %{tenant_id: assigns[:tenant_id]}

    item = item_fixture(attrs)
    %{item: item}
  end
end
