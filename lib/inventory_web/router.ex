defmodule InventoryWeb.Router do
  use InventoryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InventoryWeb do
    pipe_through :api

    resources "/companies", CompanyController, except: [:new, :edit] do
      resources "/warehouses", WarehouseController, only: [:index]
    end

    resources "/warehouses", WarehouseController, except: [:new, :edit]
    resources "/items", ItemController, except: [:new, :edit]
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
