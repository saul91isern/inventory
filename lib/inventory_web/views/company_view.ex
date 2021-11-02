defmodule InventoryWeb.CompanyView do
  use InventoryWeb, :view
  alias InventoryWeb.CompanyView

  def render("index.json", %{companies: companies}) do
    %{data: render_many(companies, CompanyView, "company.json")}
  end

  def render("show.json", %{company: company}) do
    %{data: render_one(company, CompanyView, "company.json")}
  end

  def render("company.json", %{company: company}) do
    %{
      id: company.id,
      name: company.name,
      tenant_id: company.tenant_id
    }
  end
end
