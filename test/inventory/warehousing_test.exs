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
      assert Warehousing.list_warehouses() == [warehouse]
    end

    test "get_warehouse!/1 returns the warehouse with given id" do
      warehouse = warehouse_fixture()
      assert Warehousing.get_warehouse!(warehouse.id) == warehouse
    end

    test "create_warehouse/1 with valid data creates a warehouse" do
      valid_attrs = %{address: "some address", name: "some name", tenant_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Warehouse{} = warehouse} = Warehousing.create_warehouse(valid_attrs)
      assert warehouse.address == "some address"
      assert warehouse.name == "some name"
      assert warehouse.tenant_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_warehouse/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehousing.create_warehouse(@invalid_attrs)
    end

    test "update_warehouse/2 with valid data updates the warehouse" do
      warehouse = warehouse_fixture()
      update_attrs = %{address: "some updated address", name: "some updated name", tenant_id: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Warehouse{} = warehouse} = Warehousing.update_warehouse(warehouse, update_attrs)
      assert warehouse.address == "some updated address"
      assert warehouse.name == "some updated name"
      assert warehouse.tenant_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_warehouse/2 with invalid data returns error changeset" do
      warehouse = warehouse_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehousing.update_warehouse(warehouse, @invalid_attrs)
      assert warehouse == Warehousing.get_warehouse!(warehouse.id)
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
end
