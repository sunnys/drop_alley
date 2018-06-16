defmodule DropAlleyWeb.PartnerController do
  use DropAlleyWeb, :controller

  alias DropAlley.ChannelPartner
  alias DropAlley.ChannelPartner.Partner

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case ChannelPartner.paginate_partners(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Partners. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.partner_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = ChannelPartner.change_partner(%Partner{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"partner" => partner_params}) do
    case ChannelPartner.create_partner(partner_params) do
      {:ok, partner} ->
        conn
        |> put_flash(:info, "Partner created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.partner_path(conn, :show, partner))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    partner = ChannelPartner.get_partner!(id)
    render(conn, "show.html", partner: partner)
  end

  def edit(conn, %{"id" => id}) do
    partner = ChannelPartner.get_partner!(id)
    changeset = ChannelPartner.change_partner(partner)
    render(conn, "edit.html", partner: partner, changeset: changeset)
  end

  def update(conn, %{"id" => id, "partner" => partner_params}) do
    partner = ChannelPartner.get_partner!(id)

    case ChannelPartner.update_partner(partner, partner_params) do
      {:ok, partner} ->
        conn
        |> put_flash(:info, "Partner updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.partner_path(conn, :show, partner))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", partner: partner, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = ChannelPartner.get_partner!(id)
    {:ok, _partner} = ChannelPartner.delete_partner(partner)

    conn
    |> put_flash(:info, "Partner deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.partner_path(conn, :index))
  end
end