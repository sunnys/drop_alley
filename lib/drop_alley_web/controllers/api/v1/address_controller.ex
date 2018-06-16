defmodule DropAlleyWeb.API.V1.AddressController do
  use DropAlleyWeb, :controller

  alias DropAlley.UserInformation
  alias DropAlley.UserInformation.Address

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    addresses = UserInformation.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    with {:ok, %Address{} = address} <- UserInformation.create_address(address_params) do
      conn
      |> put_status(:created)
      |> render("show.json", address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = UserInformation.get_address!(id)
    render(conn, "show.json", address: address)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = UserInformation.get_address!(id)

    with {:ok, %Address{} = address} <- UserInformation.update_address(address, address_params) do
      render(conn, "show.json", address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = UserInformation.get_address!(id)
    with {:ok, %Address{}} <- UserInformation.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
