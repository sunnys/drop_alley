defmodule DropAlleyWeb.UserIdentityController do
  use DropAlleyWeb, :controller

  alias DropAlley.Account
  alias DropAlley.Account.UserIdentity

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Account.paginate_user_identities(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering User identities. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.user_identity_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Account.change_user_identity(%UserIdentity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_identity" => user_identity_params}) do
    case Account.create_user_identity(user_identity_params) do
      {:ok, user_identity} ->
        conn
        |> put_flash(:info, "User identity created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, user_identity))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_identity = Account.get_user_identity!(id)
    render(conn, "show.html", user_identity: user_identity)
  end

  def edit(conn, %{"id" => id}) do
    user_identity = Account.get_user_identity!(id)
    changeset = Account.change_user_identity(user_identity)
    render(conn, "edit.html", user_identity: user_identity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_identity" => user_identity_params}) do
    user_identity = Account.get_user_identity!(id)

    case Account.update_user_identity(user_identity, user_identity_params) do
      {:ok, user_identity} ->
        conn
        |> put_flash(:info, "User identity updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, user_identity))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_identity: user_identity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_identity = Account.get_user_identity!(id)
    {:ok, _user_identity} = Account.delete_user_identity(user_identity)

    conn
    |> put_flash(:info, "User identity deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.user_identity_path(conn, :index))
  end
end