defmodule DropAlleyWeb.API.V1.SessionController do
  use DropAlleyWeb, :controller

  action_fallback DropAlleyWeb.FallbackController

  def create(conn, params) do
    case DropAlley.Auth.authenticate_user(params) do
        {:ok, user} ->
            {:ok, token, claims} = DropAlley.Auth.generate_token(user)
            exp = Map.get(claims, "exp") #Extract expiry from claims to add as a response header
            conn
            |> put_status(:created)
            |> put_resp_header("authorization", "bearer #{token}")
            |> put_resp_header("x-expires", "#{exp}")
            |> render("show.json", user: user, jwt: token)

        {:error, _reason} ->
            conn
            |> put_status(:unauthorized)
            |> render("error.json")
    end
  end

  def delete(conn, _) do
      conn
      |> DropAlley.Auth.logout()
      |> put_status(:ok)
      |> render("delete.json")
  end
end