defmodule Inventory.WarehousingTest do
  use Inventory.DataCase

  alias Inventory.Warehousing

  describe "companies" do
    alias Inventory.Warehousing.Company

    import Inventory.WarehousingFixtures

    @invalid_attrs %{name: nil, tenant_id: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Warehousing.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Warehousing.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      tenant_id = Ecto.UUID.generate()
      valid_attrs = %{name: "some name", tenant_id: tenant_id}

      assert {:ok, %Company{} = company} = Warehousing.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.tenant_id == tenant_id
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehousing.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      tenant_id = Ecto.UUID.generate()
      company = company_fixture()
      update_attrs = %{name: "some updated name", tenant_id: tenant_id}

      assert {:ok, %Company{} = company} = Warehousing.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.tenant_id == tenant_id
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehousing.update_company(company, @invalid_attrs)
      assert company == Warehousing.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Warehousing.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Warehousing.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Warehousing.change_company(company)
    end
  end

  describe "warehouses" do
    alias Inventory.Warehousing.Warehouse

    import Inventory.WarehousingFixtures

    @invalid_attrs %{address: nil, name: nil, tenant_id: nil}

    test "list_warehouses/0 returns all warehouses" do
      warehouse = warehouse_fixture()
      assert [result] = Warehousing.list_warehouses()
      assert Map.drop(result, [:company]) == Map.drop(warehouse, [:company])
    end

    test "list_warehouses/1 returns all warehouses for a given company" do
      warehouse = warehouse_fixture()
      company_id = warehouse.company_id
      assert [result] = Warehousing.list_warehouses(%{company_id: company_id})
      assert Map.drop(result, [:company]) == Map.drop(warehouse, [:company])
    end

    test "get_warehouse!/1 returns the warehouse with given id" do
      warehouse = warehouse_fixture()
      result = Warehousing.get_warehouse!(warehouse.id)
      assert Map.drop(result, [:company]) == Map.drop(warehouse, [:company])
    end

    test "create_warehouse/1 with valid data creates a warehouse" do
      company = company_fixture()

      valid_attrs = %{
        address: "some address",
        name: "some name",
        tenant_id: company.tenant_id
      }

      assert {:ok, %Warehouse{} = warehouse} = Warehousing.create_warehouse(valid_attrs, company)
      assert warehouse.address == "some address"
      assert warehouse.name == "some name"
      assert warehouse.tenant_id == company.tenant_id
    end

    test "create_warehouse/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehousing.create_warehouse(@invalid_attrs)
    end

    test "update_warehouse/2 with valid data updates the warehouse" do
      warehouse = warehouse_fixture()

      update_attrs = %{
        address: "some updated address",
        name: "some updated name",
        tenant_id: warehouse.tenant_id
      }

      assert {:ok, %Warehouse{} = warehouse} =
               Warehousing.update_warehouse(warehouse, update_attrs)

      assert warehouse.address == "some updated address"
      assert warehouse.name == "some updated name"
      assert warehouse.tenant_id == warehouse.tenant_id
    end

    test "update_warehouse/2 with invalid data returns error changeset" do
      warehouse = warehouse_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehousing.update_warehouse(warehouse, @invalid_attrs)

      assert Map.drop(warehouse, [:company]) ==
               Map.drop(Warehousing.get_warehouse!(warehouse.id), [:company])
    end

    test "delete_warehouse/1 deletes the warehouse" do
      warehouse = warehouse_fixture()
      assert {:ok, %Warehouse{}} = Warehousing.delete_warehouse(warehouse)
      assert_raise Ecto.NoResultsError, fn -> Warehousing.get_warehouse!(warehouse.id) end
    end

    test "change_warehouse/1 returns a warehouse changeset" do
      warehouse = warehouse_fixture()
      assert %Ecto.Changeset{} = Warehousing.change_warehouse(warehouse)
    end
  end

  describe "items" do
    alias Inventory.Warehousing.Item

    import Inventory.WarehousingFixtures

    @invalid_attrs %{description: nil, sku: nil, tenant_id: nil, unit: nil, weight: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      [result] = Warehousing.list_items()
      assert Map.drop(result, [:company, :warehouse]) == Map.drop(item, [:company, :warehouse])
    end

    test "list_items/1 returns all items with filters" do
      item = item_fixture()
      company_id = item.company_id
      sku = item.sku
      assert [result] = Warehousing.list_items(%{company_id: company_id})
      assert Map.drop(result, [:company, :warehouse]) == Map.drop(item, [:company, :warehouse])

      assert [result] = Warehousing.list_items(%{sku: sku})
      assert Map.drop(result, [:company, :warehouse]) == Map.drop(item, [:company, :warehouse])

      assert [] = Warehousing.list_items(%{sku: "foo"})
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      result = Warehousing.get_item!(item.id)
      assert Map.drop(result, [:company, :warehouse]) == Map.drop(item, [:company, :warehouse])
    end

    test "create_item/1 with valid data creates a item" do
      tenant_id = Ecto.UUID.generate()
      ext_attrs = %{tenant_id: tenant_id}
      warehouse = warehouse_fixture(ext_attrs)
      company = company_fixture(ext_attrs)

      valid_attrs = %{
        description: "some description",
        sku: "some sku",
        unit: "ea",
        weight: 42,
        tenant_id: tenant_id
      }

      assert {:ok, %Item{} = item} = Warehousing.create_item(valid_attrs, company, warehouse)
      assert item.description == "some description"
      assert item.sku == "some sku"
      assert item.tenant_id == tenant_id
      assert item.unit == String.to_atom("ea")
      assert item.weight == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      tenant_id = Ecto.UUID.generate()
      ext_attrs = %{tenant_id: tenant_id}
      warehouse = warehouse_fixture(ext_attrs)
      company = company_fixture(ext_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Warehousing.create_item(@invalid_attrs, company, warehouse)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()

      update_attrs = %{
        description: "some updated description",
        sku: "some updated sku",
        tenant_id: item.tenant_id,
        unit: "pl",
        weight: 43
      }

      assert {:ok, %Item{} = item} = Warehousing.update_item(item, update_attrs)
      assert item.description == "some updated description"
      assert item.sku == "some updated sku"
      assert item.unit == String.to_atom("pl")
      assert item.weight == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehousing.update_item(item, @invalid_attrs)

      assert Map.drop(item, [:warehouse, :company]) ==
               Map.drop(Warehousing.get_item!(item.id), [:warehouse, :company])
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Warehousing.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Warehousing.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Warehousing.change_item(item)
    end
  end
end
