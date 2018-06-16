defmodule DropAlleyWeb.BuyerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Buyer

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_buyers(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Buyers. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.buyer_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_buyer(%Buyer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"buyer" => buyer_params}) do
    case Store.create_buyer(buyer_params) do
      {:ok, buyer} ->
        conn
        |> put_flash(:info, "Buyer created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.buyer_path(conn, :show, buyer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    buyer = Store.get_buyer!(id)
    render(conn, "show.html", buyer: buyer)
  end

  def edit(conn, %{"id" => id}) do
    buyer = Store.get_buyer!(id)
    changeset = Store.change_buyer(buyer)
    render(conn, "edit.html", buyer: buyer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "buyer" => buyer_params}) do
    buyer = Store.get_buyer!(id)

    case Store.update_buyer(buyer, buyer_params) do
      {:ok, buyer} ->
        conn
        |> put_flash(:info, "Buyer updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.buyer_path(conn, :show, buyer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", buyer: buyer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    buyer = Store.get_buyer!(id)
    {:ok, _buyer} = Store.delete_buyer(buyer)

    conn
    |> put_flash(:info, "Buyer deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.buyer_path(conn, :index))
  end
end