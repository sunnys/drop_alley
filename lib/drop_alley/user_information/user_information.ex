defmodule DropAlley.UserInformation do
  @moduledoc """
  The UserInformation context.
  """

  import Ecto.Query, warn: false
  alias DropAlley.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias DropAlley.UserInformation.Address

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of addresses using filtrex
filters.

## Examples

    iex> list_addresses(%{})
    %{addresses: [%Address{}], ...}
"""
@spec paginate_addresses(map) :: {:ok, map} | {:error, any}
def paginate_addresses(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:addresses), params["address"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_addresses(filter, params) do
    {:ok,
      %{
        addresses: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_addresses(filter, params) do
  Address
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of addresses.

## Examples

    iex> list_addresses()
    [%Address{}, ...]

"""
def list_addresses do
  Repo.all(Address)
end

@doc """
Gets a single address.

Raises `Ecto.NoResultsError` if the Address does not exist.

## Examples

    iex> get_address!(123)
    %Address{}

    iex> get_address!(456)
    ** (Ecto.NoResultsError)

"""
def get_address!(id), do: Repo.get!(Address, id)

@doc """
Creates a address.

## Examples

    iex> create_address(%{field: value})
    {:ok, %Address{}}

    iex> create_address(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_address(attrs \\ %{}) do
  %Address{}
  |> Address.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a address.

## Examples

    iex> update_address(address, %{field: new_value})
    {:ok, %Address{}}

    iex> update_address(address, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_address(%Address{} = address, attrs) do
  address
  |> Address.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Address.

## Examples

    iex> delete_address(address)
    {:ok, %Address{}}

    iex> delete_address(address)
    {:error, %Ecto.Changeset{}}

"""
def delete_address(%Address{} = address) do
  Repo.delete(address)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking address changes.

## Examples

    iex> change_address(address)
    %Ecto.Changeset{source: %Address{}}

"""
def change_address(%Address{} = address) do
  Address.changeset(address, %{})
end

defp filter_config(:addresses) do
  defconfig do
    boolean :active
      text :addr
      text :street
      text :city
      text :state
      text :pincode
      text :contact_no
      
  end
end
end
