defmodule DropAlleyWeb.AddressController do
  use DropAlleyWeb, :controller

  alias DropAlley.UserInformation
  alias DropAlley.UserInformation.Address

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case UserInformation.paginate_addresses(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Addresses. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.address_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = UserInformation.change_address(%Address{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"address" => address_params}) do
    case UserInformation.create_address(address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.address_path(conn, :show, address))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    address = UserInformation.get_address!(id)
    render(conn, "show.html", address: address)
  end

  def edit(conn, %{"id" => id}) do
    address = UserInformation.get_address!(id)
    changeset = UserInformation.change_address(address)
    render(conn, "edit.html", address: address, changeset: changeset)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = UserInformation.get_address!(id)

    case UserInformation.update_address(address, address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.address_path(conn, :show, address))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = UserInformation.get_address!(id)
    {:ok, _address} = UserInformation.delete_address(address)

    conn
    |> put_flash(:info, "Address deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.address_path(conn, :index))
  end
end