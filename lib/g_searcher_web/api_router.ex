defmodule GSearcherWeb.APIRouter do
  use GSearcherWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug JSONAPI.Deserializer
    plug JSONAPI.UnderscoreParameters
  end

  pipeline :ensure_spec do
    plug JSONAPI.EnsureSpec
  end

  pipeline :authentication do
    plug Guardian.Plug.Pipeline,
      module: GSearcher.Tokenizer,
      error_handler: GSearcherWeb.ErrorHandler

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
    plug GSearcherWeb.Plugs.API.SetUser
  end

  scope "/api", GSearcherWeb.API, as: :api do
    pipe_through :api

    scope "/auth" do
      get "/:provider", AuthenticationController, :request
      get "/:provider/callback", AuthenticationController, :callback
    end
  end

  scope "/api", GSearcherWeb.API, as: :api do
    pipe_through [:api, :authentication]

    post "/reports", ReportController, :create
  end

  scope "/api", GSearcherWeb.API, as: :api do
    pipe_through [:api, :authentication, :ensure_spec]

    get "/search_results", SearchResultController, :index
    get "/search-result/:id", SearchResultController, :show
  end
end
