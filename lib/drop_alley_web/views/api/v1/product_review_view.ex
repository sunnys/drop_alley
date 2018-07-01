defmodule DropAlleyWeb.API.V1.ProductReviewView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.ProductReviewView

  def render("index.json", %{product_reviews: product_reviews}) do
    %{data: render_many(product_reviews, ProductReviewView, "product_review.json")}
  end

  def render("show.json", %{product_review: product_review}) do
    %{data: render_one(product_review, ProductReviewView, "product_review.json")}
  end

  def render("product_review.json", %{product_review: product_review}) do
    %{id: product_review.id,
      name: product_review.name,
      rating: product_review.rating,
      image: product_review.image}
  end
end
