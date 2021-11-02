defmodule InventoryWeb.CompanyController do
  use InventoryWeb, :controller

  alias Inventory.Warehousing
  alias Inventory.Warehousing.Company

  action_fallback InventoryWeb.FallbackController

  def index(conn, _params) do
    companies = Warehousing.list_companies()
    render(conn, "index.json", companies: companies)
  end

  def create(conn, %{"data" => company_params}) do
    with {:ok, %Company{} = company} <- Warehousing.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.company_path(conn, :show, company))
      |> render("show.json", company: company)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Warehousing.get_company!(id)
    render(conn, "show.json", company: company)
  end

  def update(conn, %{"id" => id, "data" => company_params}) do
    company = Warehousing.get_company!(id)

    with {:ok, %Company{} = company} <- Warehousing.update_company(company, company_params) do
      render(conn, "show.json", company: company)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Warehousing.get_company!(id)

    with {:ok, %Company{}} <- Warehousing.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end
end
