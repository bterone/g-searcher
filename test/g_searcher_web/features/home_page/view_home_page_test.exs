defmodule GSearcherWeb.HomePage.ViewHomePageTest do
  use GSearcherWeb.FeatureCase

  feature "view home page", %{session: session} do
    session
    |> visit(Routes.page_path(GSearcherWeb.Endpoint, :index))

    session
    |> assert_has(Query.text("No business can sell what is already made"))
  end
end
