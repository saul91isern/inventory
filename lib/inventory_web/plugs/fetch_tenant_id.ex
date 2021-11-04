defmodule InventoryWeb.FetchTenantId do
  import Plug.Conn

  alias Inventory.Repo

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    case get_req_header(conn, "tenant-id") do
      [tenant_id] ->
        Repo.put_tenant_id(tenant_id)
        conn

      _ ->
        conn
        |> put_status(400)
        |> Phoenix.Controller.put_view(InventoryWeb.ErrorView)
        |> Phoenix.Controller.render("missing_tenant_id.json")
        |> halt()
    end
  end
end
