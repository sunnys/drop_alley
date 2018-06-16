defmodule DropAlleyWeb.API.V1.PartnerView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.PartnerView

  def render("index.json", %{partners: partners}) do
    %{data: render_many(partners, PartnerView, "partner.json")}
  end

  def render("show.json", %{partner: partner}) do
    %{data: render_one(partner, PartnerView, "partner.json")}
  end

  def render("partner.json", %{partner: partner}) do
    %{id: partner.id,
      name: partner.name,
      active: partner.active,
      verified: partner.verified,
      contact_no: partner.contact_no,
      address: partner.address,
      current_location: partner.current_location,
      active: partner.active}
  end
end
