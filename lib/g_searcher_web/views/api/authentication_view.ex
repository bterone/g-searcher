defmodule GSearcherWeb.API.AuthenticationView do
  use GSearcherWeb, :view

  def render("token.json", %{access_token: access_token}) do
    %{
      object: "token",
      access_token: access_token
    }
  end
end
