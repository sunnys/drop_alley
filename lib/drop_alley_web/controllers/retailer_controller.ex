defmodule DropAlleyWeb.RetailerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Retailer

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_retailers(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Retailers. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.retailer_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_retailer(%Retailer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"retailer" => retailer_params}) do
    case Store.create_retailer(retailer_params) do
      {:ok, retailer} ->
        conn
        |> put_flash(:info, "Retailer created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, retailer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    retailer = Store.get_retailer!(id)
    render(conn, "show.html", retailer: retailer)
  end

  def edit(conn, %{"id" => id}) do
    retailer = Store.get_retailer!(id)
    changeset = Store.change_retailer(retailer)
    render(conn, "edit.html", retailer: retailer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "retailer" => retailer_params}) do
    retailer = Store.get_retailer!(id)

    case Store.update_retailer(retailer, retailer_params) do
      {:ok, retailer} ->
        conn
        |> put_flash(:info, "Retailer updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, retailer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", retailer: retailer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    retailer = Store.get_retailer!(id)
    {:ok, _retailer} = Store.delete_retailer(retailer)

    conn
    |> put_flash(:info, "Retailer deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.retailer_path(conn, :index))
  end
end