defmodule DropAlleyWeb.API.V1.ProductReviewController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ProductReview

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    product_reviews = Store.list_product_reviews()
    render(conn, "index.json", product_reviews: product_reviews)
  end

  def create(conn, %{"product_review" => product_review_params}) do
    with {:ok, %ProductReview{} = product_review} <- Store.create_product_review(product_review_params) do
      conn
      |> put_status(:created)
      |> render("show.json", product_review: product_review)
    end
  end

  def show(conn, %{"id" => id}) do
    product_review = Store.get_product_review!(id)
    render(conn, "show.json", product_review: product_review)
  end

  def update(conn, %{"id" => id, "product_review" => product_review_params}) do
    product_review = Store.get_product_review!(id)

    with {:ok, %ProductReview{} = product_review} <- Store.update_product_review(product_review, product_review_params) do
      render(conn, "show.json", product_review: product_review)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_review = Store.get_product_review!(id)
    with {:ok, %ProductReview{}} <- Store.delete_product_review(product_review) do
      send_resp(conn, :no_content, "")
    end
  end
end
