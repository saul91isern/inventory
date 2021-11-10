defmodule InventoryWeb.ItemController do
  use InventoryWeb, :controller

  alias Inventory.Warehousing
  alias Inventory.Warehousing.{Company, Item, Warehouse}

  action_fallback InventoryWeb.FallbackController

  def index(conn, params) do
    params = item_params(params)
    items = Warehousing.list_items(params)
    render(conn, "index.json", items: items)
  end

  def create(conn, %{
        "company_id" => company_id,
        "warehouse_id" => warehouse_id,
        "data" => item_params
      }) do
    item_params = put_tenant_id(item_params)

    with %Company{} = company <- Warehousing.get_company!(company_id),
         %Warehouse{} = warehouse <- Warehousing.get_warehouse!(warehouse_id),
         {:ok, %Item{} = item} <- Warehousing.create_item(item_params, company, warehouse) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Warehousing.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "data" => item_params}) do
    item = Warehousing.get_item!(id)

    with {:ok, %Item{} = item} <- Warehousing.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Warehousing.get_item!(id)

    with {:ok, %Item{}} <- Warehousing.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end

  defp item_params(params) do
    Enum.reduce(params, %{}, fn {"company_id", company_id}, acc ->
      Map.put(acc, :company_id, company_id)
    end)
  end
end
