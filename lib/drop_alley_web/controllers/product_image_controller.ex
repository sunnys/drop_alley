defmodule DropAlleyWeb.ProductImageController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ProductImage

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_product_images(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Product images. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_image_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_product_image(%ProductImage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product_image" => product_image_params}) do
    case Store.create_product_image(product_image_params) do
      {:ok, product_image} ->
        conn
        |> put_flash(:info, "Product image created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, product_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_image = Store.get_product_image!(id)
    render(conn, "show.html", product_image: product_image)
  end

  def edit(conn, %{"id" => id}) do
    product_image = Store.get_product_image!(id)
    changeset = Store.change_product_image(product_image)
    render(conn, "edit.html", product_image: product_image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_image" => product_image_params}) do
    product_image = Store.get_product_image!(id)

    case Store.update_product_image(product_image, product_image_params) do
      {:ok, product_image} ->
        conn
        |> put_flash(:info, "Product image updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, product_image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product_image: product_image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_image = Store.get_product_image!(id)
    {:ok, _product_image} = Store.delete_product_image(product_image)

    conn
    |> put_flash(:info, "Product image deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.product_image_path(conn, :index))
  end
end