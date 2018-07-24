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
        IO.inspect assigns.filter.conditions
        render(conn, "product_index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Products. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
    end
  end

  def product_show(conn, %{"id" => id}) do
    conn = put_layout conn, {DropAlleyWeb.LayoutView, "product.html"}
    product = Store.get_product_with_detail!(id)
    is_available = true
    render(conn, "product_show.html", [product: product, is_available: is_available])
  end

  def product_checkout(conn, %{"id" => id, "size" => size}) do
    conn = put_layout conn, {DropAlleyWeb.LayoutView, "product.html"}
    IO.inspect conn
    product = Store.get_product_with_detail!(id)
    render(conn, "product_checkout.html", product: product)
  end

  def import(conn, _param) do
    render(conn, "import.html")  
  end

  def save_import(conn, params) do
    file_path = params["product"]["file"].path
    Store.create_bulk_product(file_path)
    case Store.paginate_products(%{}) do
      {:ok, assigns} ->
        conn
        |> put_flash(:success, "Product Data imported")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Products. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_path(conn, :index))
    end
  end

  def book_order(conn, %{"id" => id, "order" => order_params}) do
    user_changeset = %{
      name: order_params["first_name"] <> order_params["last_name"], 
      email: order_params["email"], 
      password: "secret", 
      password_confirmation: "secret"
    }
    order = %{
      active: true, 
      paid: false, 
      payment_type: "COD", 
      purchase: true, 
      state: "new",
      trail: true,
      size: order_params["size"]
    }
    address = %{
      active: true, 
      addr: order_params["addr"], 
      street: order_params["street"],
      city: order_params["city"],
      state: order_params["state"], 
      pincode: order_params["pincode"],
      country: order_params["country"], 
      contact_no: order_params["contact_no"]
    }
    case DropAlley.Purchase.call(order, address, user_changeset, id) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.show_order_path(conn, :show_order, order[:order]))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end