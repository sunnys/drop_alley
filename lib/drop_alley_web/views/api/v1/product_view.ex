defmodule DropAlleyWeb.API.V1.ProductView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      prprice: product.prprice,
      state: product.state,
      retailer_id: product.retaier_id,
      return_consumer_id: product.return_consumer_id,
      return_code: product.return_code,
      inspection_process: product.inspection_process}
  end
end
