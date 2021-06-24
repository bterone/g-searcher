defmodule GSearcherWeb.ErrorViewTest do
  use GSearcherWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  alias GSearcherWeb.ErrorView

  test "renders 404.html" do
    assert render_to_string(ErrorView, "404.html", []) =~ "Page not found"
  end

  test "renders 500.html" do
    assert render_to_string(ErrorView, "500.html", []) =~ "Something has gone wrong"
  end

  test "renders json error" do
    assert ErrorView.render("error.json", %{status: 500, message: "Internal Server Error"}) == %{
             errors: [
               %{status: 500, detail: "Internal Server Error"}
             ]
           }
  end

  test "renders status from template" do
    assert render_to_string(ErrorView, "418.html", []) =~ "I&#39;m a teapot"
  end
end
