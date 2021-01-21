defmodule GSearcherWeb.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcherWeb.{DashboardController, DashboardView}
  alias GSearcherWeb.Validators.{CreateReportParams, ParamValidator}

  def create(conn, %{"report" => report_params}) do
    user = conn.assigns.current_user

    with {:ok, %{title: title, csv: csv}} <-
           ParamValidator.validate(report_params, for: CreateReportParams),
         {:ok, _report} <- Reports.create_report(user.id, title, csv.path) do
      conn
      |> put_flash(:info, "Report generated successfully.")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      {:error, :invalid_params, %Ecto.Changeset{} = report_changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> put_view(DashboardView)
        |> replace_path_info_to_dashboard()
        |> DashboardController.index(%{create_report: report_changeset})

      {:error, :failed_to_save_keywords} ->
        conn
        |> put_flash(:error, "Failed to save from file.")
        |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end

  defp replace_path_info_to_dashboard(conn) do
    %{conn | path_info: "dashboard"}
  end
end
