defmodule Inventory.Shipping do
  @moduledoc """
  The Shipping context.
  """

  import Ecto.Query, warn: false
  alias Inventory.Repo

  alias Inventory.Shipping.Shipment

  @doc """
  Returns the list of shipments.

  ## Examples

      iex> list_shipments(params)
      [%Shipment{}, ...]

  """
  def list_shipments(params \\ %{}) do
    params
    |> Enum.reduce(
      Shipment,
      fn
        {:company_id, company_id}, q -> where(q, [w], w.company_id == ^company_id)
        _, q -> q
      end
    )
    |> Repo.all()
  end

  @doc """
  Gets a single shipment.

  Raises `Ecto.NoResultsError` if the Shipment does not exist.

  ## Examples

      iex> get_shipment!(123)
      %Shipment{}

      iex> get_shipment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipment!(id), do: Repo.get!(Shipment, id)

  @doc """
  Creates a shipment.

  ## Examples

      iex> create_shipment(%{field: value}, company)
      {:ok, %Shipment{}}

      iex> create_shipment(%{field: bad_value}, company)
      {:error, %Ecto.Changeset{}}

  """
  def create_shipment(attrs \\ %{}, company) do
    %Shipment{}
    |> Shipment.changeset(attrs)
    |> Shipment.put_company(company)
    |> Repo.insert()
  end

  @doc """
  Updates a shipment.

  ## Examples

      iex> update_shipment(shipment, %{field: new_value})
      {:ok, %Shipment{}}

      iex> update_shipment(shipment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipment(%Shipment{} = shipment, attrs) do
    shipment
    |> Shipment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shipment.

  ## Examples

      iex> delete_shipment(shipment)
      {:ok, %Shipment{}}

      iex> delete_shipment(shipment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipment(%Shipment{} = shipment) do
    Repo.delete(shipment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipment changes.

  ## Examples

      iex> change_shipment(shipment)
      %Ecto.Changeset{data: %Shipment{}}

  """
  def change_shipment(%Shipment{} = shipment, attrs \\ %{}) do
    Shipment.changeset(shipment, attrs)
  end
end
