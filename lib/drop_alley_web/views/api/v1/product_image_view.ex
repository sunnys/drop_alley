defmodule DropAlleyWeb.API.V1.ProductImageView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.ProductImageView

  def render("index.json", %{product_images: product_images}) do
    %{data: render_many(product_images, ProductImageView, "product_image.json")}
  end

  def render("show.json", %{product_image: product_image}) do
    %{data: render_one(product_image, ProductImageView, "product_image.json")}
  end

  def render("product_image.json", %{product_image: product_image}) do
    %{id: product_image.id}
  end
end
