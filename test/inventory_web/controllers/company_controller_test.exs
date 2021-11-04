defmodule InventoryWeb.CompanyControllerTest do
  use InventoryWeb.ConnCase

  import Inventory.WarehousingFixtures

  alias Inventory.Warehousing.Company

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil, tenant_id: nil}

  setup %{conn: conn} do
    tenant_id = Ecto.UUID.generate()

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("tenant-id", tenant_id)

    {:ok, conn: conn, tenant_id: tenant_id}
  end

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create company" do
    test "renders company when data is valid", %{conn: conn, tenant_id: tenant_id} do
      conn = post(conn, Routes.company_path(conn, :create), data: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name",
               "tenant_id" => ^tenant_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update company" do
    setup [:create_company]

    test "renders company when data is valid", %{
      conn: conn,
      company: %Company{id: id} = company,
      tenant_id: tenant_id
    } do
      conn = put(conn, Routes.company_path(conn, :update, company), data: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)
      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "tenant_id" => ^tenant_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      company: company
    } do
      conn = put(conn, Routes.company_path(conn, :update, company), data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company, tenant_id: tenant_id} do
      conn = delete(conn, Routes.company_path(conn, :delete, company))
      assert response(conn, 204)
      conn = conn |> recycle() |> put_req_header("tenant-id", tenant_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.company_path(conn, :show, company))
      end
    end
  end

  defp create_company(assigns) do
    attrs = %{tenant_id: assigns[:tenant_id]}

    company = company_fixture(attrs)
    %{company: company}
  end
end
