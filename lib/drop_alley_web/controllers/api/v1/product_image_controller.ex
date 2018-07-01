defmodule DropAlleyWeb.API.V1.ProductImageController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ProductImage

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    product_images = Store.list_product_images()
    render(conn, "index.json", product_images: product_images)
  end

  def create(conn, %{"product_image" => product_image_params}) do
    with {:ok, %ProductImage{} = product_image} <- Store.create_product_image(product_image_params) do
      conn
      |> put_status(:created)
      |> render("show.json", product_image: product_image)
    end
  end

  def show(conn, %{"id" => id}) do
    product_image = Store.get_product_image!(id)
    render(conn, "show.json", product_image: product_image)
  end

  def update(conn, %{"id" => id, "product_image" => product_image_params}) do
    product_image = Store.get_product_image!(id)

    with {:ok, %ProductImage{} = product_image} <- Store.update_product_image(product_image, product_image_params) do
      render(conn, "show.json", product_image: product_image)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_image = Store.get_product_image!(id)
    with {:ok, %ProductImage{}} <- Store.delete_product_image(product_image) do
      send_resp(conn, :no_content, "")
    end
  end
end
