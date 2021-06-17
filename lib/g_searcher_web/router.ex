defmodule GSearcherWeb.Router do
  use GSearcherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GSearcherWeb.Plugs.SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug JSONAPI.EnsureSpec
    plug JSONAPI.Deserializer
    plug JSONAPI.UnderscoreParameters
  end

  pipeline :authentication do
    plug GSearcherWeb.Plugs.EnsureAuth
  end

  pipeline :api_authentication do
    plug Guardian.Plug.Pipeline,
      module: GoogleCrawler.Tokenizer,
      error_handler: GSearcherWeb.ErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
    plug GSearcherWeb.Plugs.EnsureAPIAuth
  end

  pipeline :mock_oauth do
    plug GSearcherWeb.Plugs.Tests.MockOauth
  end

  scope "/", GSearcherWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/auth", GSearcherWeb do
    pipe_through :browser

    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    delete "/sign-out", AuthenticationController, :sign_out
  end

  scope "/test_auth", GSearcherWeb do
    if Mix.env() == :test do
      pipe_through [:browser, :mock_oauth]

      get "/:provider/callback", AuthenticationController, :callback
    end
  end

  scope "/", GSearcherWeb do
    pipe_through [:browser, :authentication]

    get "/dashboard", DashboardController, :index

    post "/reports", ReportController, :create

    get "/report/:id", ReportController, :show

    get "/search-result", SearchResultController, :index
    get "/search-result/:id", SearchResultController, :show
    get "/search-result/:id/result_snapshot", SearchResultController, :result_snapshot
  end

  scope "/api", GSearcherWeb.API, as: :api do
    pipe_through :api

    scope "/auth" do
      get "/:provider", AuthenticationController, :request
      get "/:provider/callback", AuthenticationController, :callback
    end
  end

  scope "/api", GSearcherWeb.API, as: :api do
    pipe_through [:api, :api_authentication]

    # Routes that require authenication
  end

  # Other scopes may use custom stacks.
  # scope "/api", GSearcherWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      # coveralls-ignore-start
      live_dashboard "/telemtry", metrics: GSearcherWeb.Telemetry
      # coveralls-ignore-stop
    end
  end
end
