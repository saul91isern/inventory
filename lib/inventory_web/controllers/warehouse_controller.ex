defmodule InventoryWeb.WarehouseController do
  use InventoryWeb, :controller

  alias Inventory.Warehousing
  alias Inventory.Warehousing.Warehouse

  action_fallback InventoryWeb.FallbackController

  def index(conn, _params) do
    warehouses = Warehousing.list_warehouses()
    render(conn, "index.json", warehouses: warehouses)
  end

  def create(conn, %{"data" => warehouse_params}) do
    with {:ok, %Warehouse{} = warehouse} <- Warehousing.create_warehouse(warehouse_params) do
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
