defmodule GSearcherWeb.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcherWeb.DashboardView
  alias GSearcherWeb.Validators.Report, as: ReportParams
  alias GSearcherWeb.Validators.ParamValidator

  def create(conn, %{"report" => report_params}) do
    user = conn.assigns.current_user

    with {:ok, %{title: title, csv: csv}} <-
           ParamValidator.validate(report_params, for: ReportParams),
         {:ok, _report} <- Reports.create_report(user.id, title, csv.path) do
      conn
      |> put_flash(:info, "Report generated successfully.")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      {:error, :invalid_params, %Ecto.Changeset{} = report_changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> put_view(DashboardView)
        |> render("index.html", report: report_changeset)

      {:error, :failed_to_save_keywords} ->
        conn
        |> put_flash(:error, "Failed to save from file.")
        |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end
end
