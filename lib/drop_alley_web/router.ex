defmodule DropAlleyWeb.Router do
  use DropAlleyWeb, :router
  use Coherence.Router         # Add this
  use CoherenceAssent.Router 
  use PhoenixOauth2Provider.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Coherence.Authentication.Session, protected: true  # Add this
  end


  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"  ]
  end
  
  pipeline :api_auth do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug DropAlley.Auth.AuthAccessPipeline
  end
  
  pipeline :ensure_auth do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug DropAlley.Auth.AuthAccessPipeline
    plug Guardian.Plug.EnsureAuthenticated, module: DropAlley.Auth.Guardian, error_handler: DropAlley.Auth.AuthErrorHandler
  end

  pipeline :public do
    plug Coherence.Authentication.Session
  end

  pipeline :api_auth do
    plug ExOauth2Provider.Plug.VerifyHeader, realm: "Bearer"
    plug ExOauth2Provider.Plug.EnsureAuthenticated
  end

  pipeline :oauth_public do
    plug :put_secure_browser_headers
  end


  scope "/" do
    pipe_through :oauth_public
    oauth_routes :public
  end

  # Add this block
  scope "/" do
    pipe_through [:browser, :public]
    coherence_routes()
    coherence_assent_routes() 
  end

  # Add this block
  scope "/" do
    pipe_through [:browser, :protected]
    coherence_routes :protected
    oauth_routes :protected
  end

  # Add all the public routes here
  scope "/", DropAlleyWeb do
    pipe_through [:browser, :public]
    get "/", PageController, :index
    # Add public routes below
  end

  # Add all the admin routes here
  scope "/admin", DropAlleyWeb do
    pipe_through [:browser, :protected]
    resources "/users", UserController
    resources "/user_identities", UserIdentityController
    resources "/invitations", InvitationController
  end

  # Add all the protected here to provide authentication.
  scope "/", DropAlleyWeb do
    pipe_through [:browser, :protected]
    # Add protected routes below
  end

  scope "/", DropAlleyWeb do
    pipe_through :api
    scope "/v1" do
      post "/sessions", SessionsController, :create
      options "/sessions", SessionsController, :options
    end
  end
end
