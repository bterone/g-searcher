defmodule GSearcherWeb.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports

  def create(conn, %{"report" => report_params}) do
    user = conn.assigns.current_user

    with %{"title" => title, "csv" => file} <- report_params,
         {:ok, report} <- Reports.generate_report(user.id, title, file.path) do
      conn
      |> put_flash(:info, "Report generated successfully.")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:info, "Something went wrong.")
        |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end
end
