defmodule DropAlleyWeb.API.V1.RetailerView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.RetailerView

  def render("index.json", %{retailers: retailers}) do
    %{data: render_many(retailers, RetailerView, "retailer.json")}
  end

  def render("show.json", %{retailer: retailer}) do
    %{data: render_one(retailer, RetailerView, "retailer.json")}
  end

  def render("retailer.json", %{retailer: retailer}) do
    %{id: retailer.id,
      name: retailer.name,
      api_key: retailer.api_key,
      details: retailer.details,
      active: retailer.active}
  end
end
