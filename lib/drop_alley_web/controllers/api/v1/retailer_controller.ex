defmodule DropAlleyWeb.API.V1.RetailerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.Retailer

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    retailers = Store.list_retailers()
    render(conn, "index.json", retailers: retailers)
  end

  def create(conn, %{"retailer" => retailer_params}) do
    with {:ok, %Retailer{} = retailer} <- Store.create_retailer(retailer_params) do
      conn
      |> put_status(:created)
      |> render("show.json", retailer: retailer)
    end
  end

  def show(conn, %{"id" => id}) do
    retailer = Store.get_retailer!(id)
    render(conn, "show.json", retailer: retailer)
  end

  def update(conn, %{"id" => id, "retailer" => retailer_params}) do
    retailer = Store.get_retailer!(id)

    with {:ok, %Retailer{} = retailer} <- Store.update_retailer(retailer, retailer_params) do
      render(conn, "show.json", retailer: retailer)
    end
  end

  def delete(conn, %{"id" => id}) do
    retailer = Store.get_retailer!(id)
    with {:ok, %Retailer{}} <- Store.delete_retailer(retailer) do
      send_resp(conn, :no_content, "")
    end
  end
end
