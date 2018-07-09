defmodule DropAlleyWeb.OrderController do
  use DropAlleyWeb, :controller

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Order

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Purchase.paginate_orders(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Orders. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.order_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Purchase.change_order(%Order{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Purchase.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.order_path(conn, :show, order))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Purchase.get_order!(id)
    render(conn, "show.html", order: order)
  end

  def show_order(conn, %{"id" => id}) do
    conn = put_layout conn, {DropAlleyWeb.LayoutView, "product.html"}
    order = Purchase.get_order!(id)
    render(conn, "show_order.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Purchase.get_order!(id)
    changeset = Purchase.change_order(order)
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Purchase.get_order!(id)

    case Purchase.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.order_path(conn, :show, order[:order].id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Purchase.get_order!(id)
    {:ok, _order} = Purchase.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.order_path(conn, :index))
  end
end