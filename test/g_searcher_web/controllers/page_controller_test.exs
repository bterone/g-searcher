defmodule GSearcherWeb.PageControllerTest do
  use GSearcherWeb.ConnCase

  describe "index/2" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end
  end
end
