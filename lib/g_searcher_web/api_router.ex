defmodule GSearcherWeb.APIRouter do
  use GSearcherWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug JSONAPI.EnsureSpec
    plug JSONAPI.Deserializer
    plug JSONAPI.UnderscoreParameters
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

    # Routes that require authenication
  end
end
