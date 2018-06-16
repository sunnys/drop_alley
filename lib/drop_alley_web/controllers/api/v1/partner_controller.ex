defmodule DropAlleyWeb.API.V1.PartnerController do
  use DropAlleyWeb, :controller

  alias DropAlley.ChannelPartner
  alias DropAlley.ChannelPartner.Partner

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    partners = ChannelPartner.list_partners()
    render(conn, "index.json", partners: partners)
  end

  def create(conn, %{"partner" => partner_params}) do
    with {:ok, %Partner{} = partner} <- ChannelPartner.create_partner(partner_params) do
      conn
      |> put_status(:created)
      |> render("show.json", partner: partner)
    end
  end

  def show(conn, %{"id" => id}) do
    partner = ChannelPartner.get_partner!(id)
    render(conn, "show.json", partner: partner)
  end

  def update(conn, %{"id" => id, "partner" => partner_params}) do
    partner = ChannelPartner.get_partner!(id)

    with {:ok, %Partner{} = partner} <- ChannelPartner.update_partner(partner, partner_params) do
      render(conn, "show.json", partner: partner)
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = ChannelPartner.get_partner!(id)
    with {:ok, %Partner{}} <- ChannelPartner.delete_partner(partner) do
      send_resp(conn, :no_content, "")
    end
  end
end
