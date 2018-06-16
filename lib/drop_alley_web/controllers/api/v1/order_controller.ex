defmodule DropAlleyWeb.API.V1.OrderController do
  use DropAlleyWeb, :controller

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Order

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    orders = Purchase.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- Purchase.create_order(order_params) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Purchase.get_order!(id)
    render(conn, "show.json", order: order)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Purchase.get_order!(id)

    with {:ok, %Order{} = order} <- Purchase.update_order(order, order_params) do
      render(conn, "show.json", order: order)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Purchase.get_order!(id)
    with {:ok, %Order{}} <- Purchase.delete_order(order) do
      send_resp(conn, :no_content, "")
    end
  end
end
