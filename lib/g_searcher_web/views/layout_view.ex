defmodule GSearcherWeb.LayoutView do
  use GSearcherWeb, :view

  def body_class_name(conn),
    do: "#{module_class_name(conn)} #{Phoenix.Controller.action_name(conn)}"

  defp module_class_name(conn) do
    conn
    |> Phoenix.Controller.controller_module()
    |> Phoenix.Naming.resource_name("Controller")
    |> String.replace("_", "-")
  end
end
