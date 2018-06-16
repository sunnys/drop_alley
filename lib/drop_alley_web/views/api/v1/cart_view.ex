defmodule DropAlleyWeb.API.V1.CartView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.CartView

  def render("index.json", %{carts: carts}) do
    %{data: render_many(carts, CartView, "cart.json")}
  end

  def render("show.json", %{cart: cart}) do
    %{data: render_one(cart, CartView, "cart.json")}
  end

  def render("cart.json", %{cart: cart}) do
    %{id: cart.id,
      state: cart.state,
      active: cart.active}
  end
end
