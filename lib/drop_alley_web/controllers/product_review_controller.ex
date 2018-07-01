defmodule DropAlleyWeb.ProductReviewController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ProductReview

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_product_reviews(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Product reviews. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_review_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_product_review(%ProductReview{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product_review" => product_review_params}) do
    case Store.create_product_review(product_review_params) do
      {:ok, product_review} ->
        conn
        |> put_flash(:info, "Product review created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, product_review))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_review = Store.get_product_review!(id)
    render(conn, "show.html", product_review: product_review)
  end

  def edit(conn, %{"id" => id}) do
    product_review = Store.get_product_review!(id)
    changeset = Store.change_product_review(product_review)
    render(conn, "edit.html", product_review: product_review, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_review" => product_review_params}) do
    product_review = Store.get_product_review!(id)

    case Store.update_product_review(product_review, product_review_params) do
      {:ok, product_review} ->
        conn
        |> put_flash(:info, "Product review updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, product_review))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product_review: product_review, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_review = Store.get_product_review!(id)
    {:ok, _product_review} = Store.delete_product_review(product_review)

    conn
    |> put_flash(:info, "Product review deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.product_review_path(conn, :index))
  end
end