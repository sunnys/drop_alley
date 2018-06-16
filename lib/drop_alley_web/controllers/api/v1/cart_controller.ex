defmodule DropAlleyWeb.API.V1.CartController do
  use DropAlleyWeb, :controller

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Cart

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    carts = Purchase.list_carts()
    render(conn, "index.json", carts: carts)
  end

  def create(conn, %{"cart" => cart_params}) do
    with {:ok, %Cart{} = cart} <- Purchase.create_cart(cart_params) do
      conn
      |> put_status(:created)
      |> render("show.json", cart: cart)
    end
  end

  def show(conn, %{"id" => id}) do
    cart = Purchase.get_cart!(id)
    render(conn, "show.json", cart: cart)
  end

  def update(conn, %{"id" => id, "cart" => cart_params}) do
    cart = Purchase.get_cart!(id)

    with {:ok, %Cart{} = cart} <- Purchase.update_cart(cart, cart_params) do
      render(conn, "show.json", cart: cart)
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = Purchase.get_cart!(id)
    with {:ok, %Cart{}} <- Purchase.delete_cart(cart) do
      send_resp(conn, :no_content, "")
    end
  end
end
