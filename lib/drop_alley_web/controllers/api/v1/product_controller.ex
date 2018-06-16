defmodule DropAlleyWeb.API.V1.ProductController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Product

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    products = Store.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Store.create_product(product_params) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Store.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Store.get_product!(id)

    with {:ok, %Product{} = product} <- Store.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Store.get_product!(id)
    with {:ok, %Product{}} <- Store.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
