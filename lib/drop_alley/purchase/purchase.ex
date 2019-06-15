defmodule DropAlley.Purchase do
  @moduledoc """
  The Purchase context.
  """
  
  import Ecto.Query, warn: false
  alias DropAlley.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config
  
  alias Ecto.Multi
  alias DropAlley.Purchase.Order
  alias DropAlley.Purchase.Cart

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of orders using filtrex
filters.

## Examples

    iex> list_orders(%{})
    %{orders: [%Order{}], ...}
"""
@spec paginate_orders(map) :: {:ok, map} | {:error, any}
def paginate_orders(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:orders), params["order"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_orders(filter, params) do
    {:ok,
      %{
        orders: page.entries,
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

defp do_paginate_orders(filter, params) do
  Order
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of orders.

## Examples

    iex> list_orders()
    [%Order{}, ...]

"""
def list_orders do
  Repo.all(Order)
end

@doc """
Gets a single order.

Raises `Ecto.NoResultsError` if the Order does not exist.

## Examples

    iex> get_order!(123)
    %Order{}

    iex> get_order!(456)
    ** (Ecto.NoResultsError)

"""
def get_order!(id), do: Repo.get!(Order, id) |> Repo.preload([:products, buyer: [user: [:addresses]]])

@doc """
Creates a order.

## Examples

    iex> create_order(%{field: value})
    {:ok, %Order{}}

    iex> create_order(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_order(attrs \\ %{}) do
  %Order{}
  |> Order.changeset(attrs)
  |> Repo.insert()
end

def call(order, address, user_changeset, product_id) do
  case transaction(order, address, user_changeset, product_id) |> Repo.transaction do
    {:ok, res} -> {:ok, res}
    {:error, _, reason, _} -> {:error, reason}
  end
end

defp transaction(order, address, user_changeset, product_id) do
  on_conflict = [set: [email: "updated"]]
  Multi.new
  |> Multi.insert(:user, DropAlley.Coherence.User.changeset(%DropAlley.Coherence.User{}, user_changeset), on_conflict: on_conflict, conflict_target: :email)
  |> Multi.run(:buyer, fn _repo, %{user: user} ->
     DropAlley.Store.Buyer.changeset(%DropAlley.Store.Buyer{}, %{user_id: user.id, active: true}) |> Repo.insert 
    end)
  |> Multi.run(:address, fn _repo, %{user: user} ->
    DropAlley.UserInformation.Address.changeset(
      %DropAlley.UserInformation.Address{}, Map.merge(%{user_id: user.id}, address)
    ) 
    |> Repo.insert 
   end)
  |> Multi.run(:order, fn _repo, %{buyer: buyer} -> 
      Order.changeset(%Order{}, Map.merge(order, %{buyer_id: buyer.id})) |> Repo.insert
    end)
  |> Multi.run(:product, fn _repo, %{order: order} -> 
      Repo.get!(DropAlley.Store.Product, product_id)
      |> DropAlley.Store.change_product
      |> DropAlley.Store.Product.changeset(%{order_id: order.id})
      |> Repo.update
    end)
end

@doc """
Updates a order.

## Examples

    iex> update_order(order, %{field: new_value})
    {:ok, %Order{}}

    iex> update_order(order, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_order(%Order{} = order, attrs) do
  order
  |> Order.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Order.

## Examples

    iex> delete_order(order)
    {:ok, %Order{}}

    iex> delete_order(order)
    {:error, %Ecto.Changeset{}}

"""
def delete_order(%Order{} = order) do
  Repo.delete(order)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking order changes.

## Examples

    iex> change_order(order)
    %Ecto.Changeset{source: %Order{}}

"""
def change_order(%Order{} = order) do
  Order.changeset(order, %{})
end

defp filter_config(:orders) do
  defconfig do
    text :state
      boolean :active
      boolean :trial
      boolean :purchase
      text :payment_type
      boolean :paid
      
  end
end

@doc """
Paginate the list of carts using filtrex
filters.

## Examples

    iex> list_carts(%{})
    %{carts: [%Cart{}], ...}
"""
@spec paginate_carts(map) :: {:ok, map} | {:error, any}
def paginate_carts(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_cart_config(:carts), params["cart"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_carts(filter, params) do
    {:ok,
      %{
        carts: page.entries,
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

defp do_paginate_carts(filter, params) do
  Cart
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of carts.

## Examples

    iex> list_carts()
    [%Cart{}, ...]

"""
def list_carts do
  Repo.all(Cart)
end

@doc """
Gets a single cart.

Raises `Ecto.NoResultsError` if the Cart does not exist.

## Examples

    iex> get_cart!(123)
    %Cart{}

    iex> get_cart!(456)
    ** (Ecto.NoResultsError)

"""
def get_cart!(id), do: Repo.get!(Cart, id)

@doc """
Creates a cart.

## Examples

    iex> create_cart(%{field: value})
    {:ok, %Cart{}}

    iex> create_cart(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_cart(attrs \\ %{}) do
  %Cart{}
  |> Cart.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a cart.

## Examples

    iex> update_cart(cart, %{field: new_value})
    {:ok, %Cart{}}

    iex> update_cart(cart, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_cart(%Cart{} = cart, attrs) do
  cart
  |> Cart.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Cart.

## Examples

    iex> delete_cart(cart)
    {:ok, %Cart{}}

    iex> delete_cart(cart)
    {:error, %Ecto.Changeset{}}

"""
def delete_cart(%Cart{} = cart) do
  Repo.delete(cart)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking cart changes.

## Examples

    iex> change_cart(cart)
    %Ecto.Changeset{source: %Cart{}}

"""
def change_cart(%Cart{} = cart) do
  Cart.changeset(cart, %{})
end

defp filter_cart_config(:carts) do
  defconfig do
    text :state
      boolean :active
      
  end
end
end
