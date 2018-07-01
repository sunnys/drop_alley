defmodule DropAlleyWeb.ProductController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Product

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_products(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Products. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case Store.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Store.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Store.get_product!(id)
    changeset = Store.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Store.get_product!(id)

    case Store.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Store.get_product!(id)
    {:ok, _product} = Store.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
  end

  def product_index(conn, params) do
    conn = put_layout conn, {DropAlleyWeb.LayoutView, "product.html"}
    case Store.paginate_products(params) do
      {:ok, assigns} ->
        render(conn, "product_index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Products. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
    end
  end
end