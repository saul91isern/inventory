defmodule InventoryWeb.ShipmentController do
  use InventoryWeb, :controller

  alias Inventory.Shipping
  alias Inventory.Shipping.Shipment

  action_fallback InventoryWeb.FallbackController

  def index(conn, _params) do
    shipments = Shipping.list_shipments()
    render(conn, "index.json", shipments: shipments)
  end

  def create(conn, %{"shipment" => shipment_params}) do
    with {:ok, %Shipment{} = shipment} <- Shipping.create_shipment(shipment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.shipment_path(conn, :show, shipment))
      |> render("show.json", shipment: shipment)
    end
  end

  def show(conn, %{"id" => id}) do
    shipment = Shipping.get_shipment!(id)
    render(conn, "show.json", shipment: shipment)
  end

  def update(conn, %{"id" => id, "shipment" => shipment_params}) do
    shipment = Shipping.get_shipment!(id)

    with {:ok, %Shipment{} = shipment} <- Shipping.update_shipment(shipment, shipment_params) do
      render(conn, "show.json", shipment: shipment)
    end
  end

  def delete(conn, %{"id" => id}) do
    shipment = Shipping.get_shipment!(id)

    with {:ok, %Shipment{}} <- Shipping.delete_shipment(shipment) do
      send_resp(conn, :no_content, "")
    end
  end
end
