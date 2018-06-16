defmodule DropAlleyWeb.API.V1.BuyerView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.BuyerView

  def render("index.json", %{buyers: buyers}) do
    %{data: render_many(buyers, BuyerView, "buyer.json")}
  end

  def render("show.json", %{buyer: buyer}) do
    %{data: render_one(buyer, BuyerView, "buyer.json")}
  end

  def render("buyer.json", %{buyer: buyer}) do
    %{id: buyer.id,
      active: buyer.active}
  end
end
