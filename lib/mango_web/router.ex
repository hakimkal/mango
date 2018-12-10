defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

  end

  pipeline :frontend do
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", MangoWeb do
    pipe_through [:browser, :frontend]

    get "/", PageController, :index
    get "/categories/:name", CategoryController, :show

    get "/register" , RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login" , SessionController, :new
    post "/login" , SessionController, :create



    post "/cart", CartController, :add
    get "/cart", CartController, :show
    put "/cart" , CartController, :update

  end

  scope "/", MangoWeb do
    pipe_through [:browser, :frontend, MangoWeb.Plugs.AuthenticateCustomer]

    get "/logout", SessionController, :delete
    get "/orders", OrderController ,:index
    get "/orders/:id", OrderController ,:show

    get "/checkout" , CheckoutController, :edit
    put "/checkout/confirm" , CheckoutController, :update

  end

  # Other scopes may use custom stacks.
  # scope "/api", MangoWeb do
  #   pipe_through :api
  # end
end
