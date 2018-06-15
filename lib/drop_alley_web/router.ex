defmodule DropAlleyWeb.Router do
  use DropAlleyWeb, :router
  use Coherence.Router         # Add this
  use CoherenceAssent.Router 

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true  # Add this
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes()
    coherence_assent_routes() 
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", DropAlleyWeb do
    pipe_through :browser
    get "/", PageController, :index
    # Add public routes below
  end

  scope "/admin", DropAlleyWeb do
    pipe_through :protected
    resources "/users", UserController
    resources "/user_identities", UserIdentityController
    resources "/invitations", InvitationController
  end

  scope "/", DropAlleyWeb do
    pipe_through :protected
    # Add protected routes below
  end
end
