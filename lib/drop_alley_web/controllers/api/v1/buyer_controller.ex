defmodule DropAlleyWeb.API.V1.BuyerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Buyer

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    buyers = Store.list_buyers()
    render(conn, "index.json", buyers: buyers)
  end

  def create(conn, %{"buyer" => buyer_params}) do
    with {:ok, %Buyer{} = buyer} <- Store.create_buyer(buyer_params) do
      conn
      |> put_status(:created)
      |> render("show.json", buyer: buyer)
    end
  end

  def show(conn, %{"id" => id}) do
    buyer = Store.get_buyer!(id)
    render(conn, "show.json", buyer: buyer)
  end

  def update(conn, %{"id" => id, "buyer" => buyer_params}) do
    buyer = Store.get_buyer!(id)

    with {:ok, %Buyer{} = buyer} <- Store.update_buyer(buyer, buyer_params) do
      render(conn, "show.json", buyer: buyer)
    end
  end

  def delete(conn, %{"id" => id}) do
    buyer = Store.get_buyer!(id)
    with {:ok, %Buyer{}} <- Store.delete_buyer(buyer) do
      send_resp(conn, :no_content, "")
    end
  end
end
