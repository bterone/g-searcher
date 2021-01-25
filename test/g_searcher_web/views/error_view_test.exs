defmodule GSearcherWeb.ErrorViewTest do
  use GSearcherWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(GSearcherWeb.ErrorView, "404.html", []) =~ "Page not found"
  end

  test "renders 500.html" do
    assert render_to_string(GSearcherWeb.ErrorView, "500.html", []) =~ "Something has gone wrong"
  end

  test "renders status from template" do
    assert render_to_string(GSearcherWeb.ErrorView, "418.html", []) =~ "I&#39;m a teapot"
  end
end
