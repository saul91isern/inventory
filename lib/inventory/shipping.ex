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

  alias Inventory.Shipping.LineItem

  @doc """
  Returns the list of line_items.

  ## Examples

      iex> list_line_items(params)
      [%LineItem{}, ...]

  """
  def list_line_items(params \\ %{}) do
    params
    |> Enum.reduce(
      LineItem,
      fn
        {:shipment_id, shipment_id}, q -> where(q, [w], w.shipment_id == ^shipment_id)
        _, q -> q
      end
    )
    |> Repo.all()
  end

  @doc """
  Gets a single line_item.

  Raises `Ecto.NoResultsError` if the Line item does not exist.

  ## Examples

      iex> get_line_item!(123)
      %LineItem{}

      iex> get_line_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_line_item!(id), do: Repo.get!(LineItem, id)

  @doc """
  Creates a line_item.

  ## Examples

      iex> create_line_item(%{field: value})
      {:ok, %LineItem{}}

      iex> create_line_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_line_item(attrs \\ %{}) do
    %LineItem{}
    |> LineItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a line_item.

  ## Examples

      iex> update_line_item(line_item, %{field: new_value})
      {:ok, %LineItem{}}

      iex> update_line_item(line_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_line_item(%LineItem{} = line_item, attrs) do
    line_item
    |> LineItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a line_item.

  ## Examples

      iex> delete_line_item(line_item)
      {:ok, %LineItem{}}

      iex> delete_line_item(line_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_line_item(%LineItem{} = line_item) do
    Repo.delete(line_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking line_item changes.

  ## Examples

      iex> change_line_item(line_item)
      %Ecto.Changeset{data: %LineItem{}}

  """
  def change_line_item(%LineItem{} = line_item, attrs \\ %{}) do
    LineItem.changeset(line_item, attrs)
  end
end
