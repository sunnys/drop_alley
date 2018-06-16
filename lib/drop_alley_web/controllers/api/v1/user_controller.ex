defmodule DropAlleyWeb.API.V1.UserController do
  use DropAlleyWeb, :controller

  alias DropAlley.Coherence.Schemas
  alias DropAlley.Coherence.User

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    users = Schemas.list_user()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Schemas.create_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", api_v1_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Schemas.get_user!(id)

    with {:ok, %User{} = user} <- Schemas.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    with {:ok, %User{}} <- Schemas.delete(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
