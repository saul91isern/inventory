defmodule InventoryWeb.ItemController do
  use InventoryWeb, :controller

  alias Inventory.Warehousing
  alias Inventory.Warehousing.Item

  action_fallback InventoryWeb.FallbackController

  def index(conn, _params) do
    items = Warehousing.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"data" => item_params}) do
    item_params = put_tenant_id(item_params)

    with {:ok, %Item{} = item} <- Warehousing.create_item(item_params) do
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
end
