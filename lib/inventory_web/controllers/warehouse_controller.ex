defmodule InventoryWeb.WarehouseController do
  use InventoryWeb, :controller

  alias Inventory.Warehousing
  alias Inventory.Warehousing.{Company, Warehouse}

  action_fallback InventoryWeb.FallbackController

  def index(conn, params) do
    warehouses = Warehousing.list_warehouses(params)
    render(conn, "index.json", warehouses: warehouses)
  end

  def create(conn, %{"data" => warehouse_params}) do
    warehouse_params = put_tenant_id(warehouse_params)
    company_id = Map.get(warehouse_params, "company_id")

    with %Company{} = company <- Warehousing.get_company!(company_id),
         {:ok, %Warehouse{} = warehouse} <-
           Warehousing.create_warehouse(warehouse_params, company) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.warehouse_path(conn, :show, warehouse))
      |> render("show.json", warehouse: warehouse)
    end
  end

  def show(conn, %{"id" => id}) do
    warehouse = Warehousing.get_warehouse!(id)
    render(conn, "show.json", warehouse: warehouse)
  end

  def update(conn, %{"id" => id, "data" => warehouse_params}) do
    warehouse = Warehousing.get_warehouse!(id)

    with {:ok, %Warehouse{} = warehouse} <-
           Warehousing.update_warehouse(warehouse, warehouse_params) do
      render(conn, "show.json", warehouse: warehouse)
    end
  end

  def delete(conn, %{"id" => id}) do
    warehouse = Warehousing.get_warehouse!(id)

    with {:ok, %Warehouse{}} <- Warehousing.delete_warehouse(warehouse) do
      send_resp(conn, :no_content, "")
    end
  end
end
