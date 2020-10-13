defmodule GSearcherWeb.HomePage.ViewHomePageTest do
  use GSearcherWeb.FeatureCase

  feature "view home page", %{session: session} do
    session
    |> visit(Routes.page_path(GSearcherWeb.Endpoint, :index))

    session
    |> assert_has(Query.text("Welcome to Phoenix!"))
  end
end
