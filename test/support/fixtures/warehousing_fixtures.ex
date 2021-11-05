defmodule Inventory.WarehousingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Inventory.Warehousing` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    tenant_id = Ecto.UUID.generate()

    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name",
        tenant_id: tenant_id
      })
      |> Inventory.Warehousing.create_company()

    Inventory.Repo.put_tenant_id(company.tenant_id)
    company
  end

  @doc """
  Generate a warehouse.
  """
  def warehouse_fixture(attrs \\ %{}) do
    tenant_id = Ecto.UUID.generate()

    ext_attrs =
      attrs
      |> Map.take([:tenant_id])
      |> Enum.into(%{
        tenant_id: tenant_id
      })

    company = company_fixture(ext_attrs)

    {:ok, warehouse} =
      attrs
      |> Enum.into(%{
        address: "some address",
        name: "some name",
        tenant_id: tenant_id
      })
      |> Inventory.Warehousing.create_warehouse(company)

    Inventory.Repo.put_tenant_id(warehouse.tenant_id)

    warehouse
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    tenant_id = Ecto.UUID.generate()

    ext_attrs =
      attrs
      |> Map.take([:tenant_id])
      |> Enum.into(%{
        tenant_id: tenant_id
      })

    warehouse = warehouse_fixture(ext_attrs)
    company = company_fixture(ext_attrs)

    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        sku: "some sku",
        tenant_id: tenant_id,
        unit: "ca",
        weight: 42
      })
      |> Inventory.Warehousing.create_item(company, warehouse)

    Inventory.Repo.put_tenant_id(item.tenant_id)
    item
  end
end
