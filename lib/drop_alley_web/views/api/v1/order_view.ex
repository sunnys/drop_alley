defmodule DropAlleyWeb.API.V1.OrderView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.OrderView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{id: order.id,
      state: order.state,
      active: order.active,
      trial: order.trial,
      purchase: order.purchase,
      payment_type: order.payment_type,
      paid: order.paid}
  end
end
