defmodule DropAlleyWeb.API.V1.SessionView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.SessionView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id}
  end

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
        data: %{
            id: user.id,
            email: user.email
        },
        meta: %{token: jwt}
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end
end
