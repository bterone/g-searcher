defmodule GSearcherWeb.LayoutView do
  use GSearcherWeb, :view

  def class_name(conn) do
    join_path(conn.path_info)
  end

  defp join_path(path) when is_list(path), do: Enum.join(path, "-")
  defp join_path(path), do: path
end
