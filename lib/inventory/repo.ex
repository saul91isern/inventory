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
end
