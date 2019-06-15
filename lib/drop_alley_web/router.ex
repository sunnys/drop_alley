defmodule DropAlleyWeb.Router do
  use DropAlleyWeb, :router
  use Pow.Phoenix.Router
  # use Pow.Extension.Phoenix.Router, otp_app: :drop_alley
  use Pow.Extension.Phoenix.Router, otp_app: :drop_alley

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    # plug Coherence.Authentication.Session, protected: true  # Add this
    plug Pow.Plug.RequireAuthenticated,
        error_handler: Pow.Phoenix.PlugErrorHandler
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
    # plug Coherence.Authentication.Session
  end

  # Add this block
  scope "/" do
    pipe_through [:browser, :public]
    # coherence_routes()
    # coherence_assent_routes() 
    pow_routes()
    # pow_extension_routes()
  end

  # Add this block
  scope "/" do
    pipe_through [:browser, :protected]
    # coherence_routes :protected
    # plug Pow.Plug.RequireAuthenticated,
        # error_handler: Pow.Phoenix.PlugErrorHandler
  end

  # Add all the public routes here
  scope "/", DropAlleyWeb do
    pipe_through [:browser, :public]
    get "/", ProductController, :product_index, as: :index
    get "/products", ProductController, :product_index, as: :product_index
    get "/products/:id", ProductController, :product_show, as: :product_show
    get "/products/:id/checkout/:size", ProductController, :product_checkout, as: :product_checkout

    post "/products/:id/book_order", ProductController, :book_order, as: :book_order
    get "/orders/:id/show_order", OrderController, :show_order, as: :show_order
    # Add public routes below
  end

  # Add all the admin routes here
  scope "/admin", DropAlleyWeb do
    pipe_through [:browser, :protected]
    get "/", ProductController, :index
    resources "/users", UserController
    resources "/user_identities", UserIdentityController
    resources "/invitations", InvitationController
    resources "/products", ProductController
    scope "/products" do
      get "/bulk/import", ProductController, :import, as: :import_product
      post "/bulk/save_import", ProductController, :save_import, as: :save_import_product
    end
    resources "/buyers", BuyerController
    resources "/addresses", AddressController
    resources "/return_consumers", ReturnConsumerController
    resources "/retailers", RetailerController
    resources "/partners", PartnerController
    resources "/orders", OrderController
    resources "/carts", CartController
    resources "/buckets", BucketController
    resources "/product_images", ProductImageController
    resources "/product_reviews", ProductReviewController
  end

  # Add all the protected here to provide authentication.
  scope "/", DropAlleyWeb do
    pipe_through [:browser, :protected]
    # Add protected routes below
  end

  scope "/api/v1", DropAlleyWeb.API.V1 do
    pipe_through :api
      post "/sessions", SessionController, :create
      options "/sessions", SessionController, :options

      post "/auth/:provider", SessionController, :oauth_create
      options "/auth/:provider", SessionController, :options
  end

  scope "/api/v1", DropAlleyWeb.API.V1 do
    pipe_through :api_auth
    resources "/users", UserController
    resources "/products", ProductController
    resources "/buyers", BuyerController
    resources "/addresses", AddressController
    resources "/return_consumers", ReturnConsumerController
    resources "/retailers", RetailerController
    resources "/partners", PartnerController
    resources "/orders", OrderController
    resources "/carts", CartController
    resources "/buckets", BucketController
    resources "/product_images", ProductImageController
    resources "/product_reviews", ProductReviewController
  end

end
