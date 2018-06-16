defmodule DropAlleyWeb.API.V1.AddressView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.AddressView

  def render("index.json", %{addresses: addresses}) do
    %{data: render_many(addresses, AddressView, "address.json")}
  end

  def render("show.json", %{address: address}) do
    %{data: render_one(address, AddressView, "address.json")}
  end

  def render("address.json", %{address: address}) do
    %{id: address.id,
      active: address.active,
      addr: address.addr,
      street: address.street,
      city: address.city,
      state: address.state,
      pincode: address.pincode,
      contact_no: address.contact_no}
  end
end
