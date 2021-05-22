defmodule GSearcherWeb.LayoutViewTest do
  use GSearcherWeb.ConnCase, async: true

  alias GSearcherWeb.LayoutView

  describe "body_class_name/1" do
    test "returns CSS class for page body with controller name", %{conn: conn} do
      conn =
        conn
        |> put_private(:phoenix_controller, HelloWorld)
        |> put_private(:phoenix_action, :show)

      assert LayoutView.body_class_name(conn) == "hello-world show"
    end
  end
end
