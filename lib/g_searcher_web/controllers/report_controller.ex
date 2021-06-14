defmodule GSearcherWeb.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcherWeb.{DashboardController, DashboardView, ErrorHandler}
  alias GSearcherWeb.Validators.{CreateReportParams, ParamsValidator}

  def create(conn, %{"report" => report_params}) do
    user = conn.assigns.current_user

    with {:ok, %{title: title, csv: csv}} <-
           ParamsValidator.validate(report_params, as: CreateReportParams),
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

  def show(conn, %{"id" => report_id}) do
    user = conn.assigns.current_user

    case Reports.get_by(%{id: report_id, user_id: user.id}) do
      {:ok, report} ->
        render(conn, "show.html", build_report_attributes(report))

      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end

  defp replace_path_info_to_dashboard(conn) do
    %{conn | path_info: "dashboard"}
  end

  defp build_report_attributes(report) do
    [
      report: report,
      search_results: Enum.with_index(report.search_results, 1),
      total_keyword_count: Reports.total_report_keywords_count(report.id),
      total_searched_keyword_count: Reports.total_searched_report_keywords_count(report.id),
      total_top_advertisers_count: Reports.total_top_advertisers_count(report.id),
      status: Reports.report_status(report)
    ]
  end
end
