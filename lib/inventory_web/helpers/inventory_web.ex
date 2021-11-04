defmodule InventoryWeb.Helpers do
  def put_tenant_id(params, opts \\ []) do
    tenant_id = Keyword.get_lazy(opts, :tenant_id, &Inventory.Repo.get_tenant_id/0)
    Map.put(params, "tenant_id", tenant_id)
  end
end
