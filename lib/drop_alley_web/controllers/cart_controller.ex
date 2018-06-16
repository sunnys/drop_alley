defmodule DropAlleyWeb.CartController do
  use DropAlleyWeb, :controller

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Cart

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Purchase.paginate_carts(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Carts. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.cart_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Purchase.change_cart(%Cart{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cart" => cart_params}) do
    case Purchase.create_cart(cart_params) do
      {:ok, cart} ->
        conn
        |> put_flash(:info, "Cart created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.cart_path(conn, :show, cart))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cart = Purchase.get_cart!(id)
    render(conn, "show.html", cart: cart)
  end

  def edit(conn, %{"id" => id}) do
    cart = Purchase.get_cart!(id)
    changeset = Purchase.change_cart(cart)
    render(conn, "edit.html", cart: cart, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cart" => cart_params}) do
    cart = Purchase.get_cart!(id)

    case Purchase.update_cart(cart, cart_params) do
      {:ok, cart} ->
        conn
        |> put_flash(:info, "Cart updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.cart_path(conn, :show, cart))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cart: cart, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = Purchase.get_cart!(id)
    {:ok, _cart} = Purchase.delete_cart(cart)

    conn
    |> put_flash(:info, "Cart deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.cart_path(conn, :index))
  end
end