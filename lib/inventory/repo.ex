defmodule Inventory.Repo do
  use Ecto.Repo,
    otp_app: :inventory,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    runtime_config =
      Inventory.Config
      |> Vapor.load!()
      |> Map.get(:db)
      |> Enum.into([])

    {:ok, Keyword.merge(config, runtime_config)}
  end

  @tenant_key {__MODULE__, :tenant_id}

  def put_tenant_id(tenant_id) do
    Process.put(@tenant_key, tenant_id)
  end

  def get_tenant_id do
    Process.get(@tenant_key)
  end

  def prepare_query(_operation, query, opts) do
    import Ecto.Query, only: [where: 2]

    cond do
      opts[:skip_tenant_id] || opts[:schema_migration] ->
        {query, opts}

      tenant_id = Keyword.get_lazy(opts, :tenant_id, &get_tenant_id/0) ->
        {where(query, tenant_id: ^tenant_id), opts}

      true ->
        raise "expected tenant_id or skip_tenant_id to be set"
    end
  end
end
