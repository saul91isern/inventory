defmodule Inventory.ShippingTest do
  use Inventory.DataCase

  alias Inventory.Shipping

  describe "shipments" do
    alias Inventory.Shipping.Shipment

    import Inventory.{ShippingFixtures, WarehousingFixtures}

    @invalid_attrs %{
      carrier: nil,
      estimated_delivery_date: nil,
      ship_date: nil,
      tenant_id: nil,
      tracking_number: nil
    }

    test "list_shipments/0 returns all shipments" do
      shipment = shipment_fixture()
      assert [result] = Shipping.list_shipments()
      assert Map.delete(result, :company) == Map.delete(shipment, :company)
    end

    test "list_shipments/1 returns all shipments with filters" do
      shipment = shipment_fixture()
      assert [result] = Shipping.list_shipments(%{company_id: shipment.company_id})
      assert Map.delete(result, :company) == Map.delete(shipment, :company)
    end

    test "get_shipment!/1 returns the shipment with given id" do
      shipment = shipment_fixture()
      result = Shipping.get_shipment!(shipment.id)
      assert Map.delete(result, :company) == Map.delete(shipment, :company)
    end

    test "create_shipment/1 with valid data creates a shipment" do
      company = company_fixture()

      valid_attrs = %{
        carrier: "some carrier",
        estimated_delivery_date: ~U[2021-11-10 12:45:00.000000Z],
        ship_date: ~U[2021-11-10 12:45:00.000000Z],
        tracking_number: "some tracking_number",
        tenant_id: company.tenant_id
      }

      assert {:ok, %Shipment{} = shipment} = Shipping.create_shipment(valid_attrs, company)
      assert shipment.carrier == "some carrier"
      assert shipment.estimated_delivery_date == ~U[2021-11-10 12:45:00.000000Z]
      assert shipment.ship_date == ~U[2021-11-10 12:45:00.000000Z]
      assert shipment.tenant_id == company.tenant_id
      assert shipment.tracking_number == "some tracking_number"
    end

    test "create_shipment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shipping.create_shipment(@invalid_attrs)
    end

    test "update_shipment/2 with valid data updates the shipment" do
      shipment = shipment_fixture()

      update_attrs = %{
        carrier: "some updated carrier",
        estimated_delivery_date: ~U[2021-11-11 12:45:00.000000Z],
        ship_date: ~U[2021-11-11 12:45:00.000000Z],
        tracking_number: "some updated tracking_number"
      }

      assert {:ok, %Shipment{} = shipment} = Shipping.update_shipment(shipment, update_attrs)
      assert shipment.carrier == "some updated carrier"
      assert shipment.estimated_delivery_date == ~U[2021-11-11 12:45:00.000000Z]
      assert shipment.ship_date == ~U[2021-11-11 12:45:00.000000Z]
      assert shipment.tracking_number == "some updated tracking_number"
    end

    test "update_shipment/2 with invalid data returns error changeset" do
      shipment = shipment_fixture()
      assert {:error, %Ecto.Changeset{}} = Shipping.update_shipment(shipment, @invalid_attrs)

      assert Map.delete(shipment, :company) ==
               Map.delete(Shipping.get_shipment!(shipment.id), :company)
    end

    test "delete_shipment/1 deletes the shipment" do
      shipment = shipment_fixture()
      assert {:ok, %Shipment{}} = Shipping.delete_shipment(shipment)
      assert_raise Ecto.NoResultsError, fn -> Shipping.get_shipment!(shipment.id) end
    end

    test "change_shipment/1 returns a shipment changeset" do
      shipment = shipment_fixture()
      assert %Ecto.Changeset{} = Shipping.change_shipment(shipment)
    end
  end
end
