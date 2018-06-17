defmodule DropAlley.Auth do
  @moduledoc false

  require Ecto.Query

  import Plug.Conn

  alias DropAlley.Auth.Guardian
  alias DropAlley.Coherence.User
  alias DropAlley.Repo

  def authenticate_user_omniauth(%{"provider" => provider, "profile" => profile}) do
    user_identity =  DropAlley.Account.UserIdentity |> Repo.get_by(%{uid: profile.googleId})
    case user_identity do
      nil ->
        changeset = User.changeset(%User{}, %{})
        user = Repo.insert()
        
      res ->
        user = Repo.get(User, res.user_id)
    end
  end

  def authenticate_user(%{"email" => email, "password" => password}) do
    query = Ecto.Query.from(u in User, where: u.email == ^email)
    Repo.one(query)
      |> check_password(password)
  end

  def generate_token(user) do
    Guardian.encode_and_sign(user) 
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}

  defp check_password(user, given_password) do
    case User.checkpw(given_password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect email or password"}
    end
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
    |> put_user_token(user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end

  def load_current_user(conn, _) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> put_user_token(Guardian.Plug.current_resource(conn))
  end

  defp put_user_token(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:user_token, token)
  end
end