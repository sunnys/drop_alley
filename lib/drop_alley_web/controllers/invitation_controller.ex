defmodule DropAlleyWeb.InvitationController do
  use DropAlleyWeb, :controller

  alias DropAlley.Account
  alias DropAlley.Account.Invitation

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Account.paginate_invitations(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Invitations. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.invitation_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Account.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invitation" => invitation_params}) do
    case Account.create_invitation(invitation_params) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.invitation_path(conn, :show, invitation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invitation = Account.get_invitation!(id)
    render(conn, "show.html", invitation: invitation)
  end

  def edit(conn, %{"id" => id}) do
    invitation = Account.get_invitation!(id)
    changeset = Account.change_invitation(invitation)
    render(conn, "edit.html", invitation: invitation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Account.get_invitation!(id)

    case Account.update_invitation(invitation, invitation_params) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.invitation_path(conn, :show, invitation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invitation: invitation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Account.get_invitation!(id)
    {:ok, _invitation} = Account.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.invitation_path(conn, :index))
  end
end