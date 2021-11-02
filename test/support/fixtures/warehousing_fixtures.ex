defmodule Inventory.WarehousingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Inventory.Warehousing` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name",
        tenant_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Inventory.Warehousing.create_company()

    company
  end
end
