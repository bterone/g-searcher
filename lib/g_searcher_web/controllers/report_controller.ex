defmodule GSearcherWeb.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.{Reports, SearchResults}
  alias GSearcherWeb.{DashboardController, DashboardView, ErrorHandler}
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

  def show(conn, %{"id" => report_id}) do
    user = conn.assigns.current_user

    with {:ok, report} <- Reports.get_by(%{id: report_id, user_id: user.id}),
         {:ok, search_results} <- SearchResults.get_search_results_from_report(report_id),
         search_results_with_index <- Enum.with_index(search_results, 1),
         total_keyword_count <- Reports.total_report_keywords_count(report_id),
         total_searched_keyword_count <- Reports.total_searched_report_keywords_count(report_id),
         total_top_advertisers_count <- Reports.total_top_advertisers_count(report_id),
         report_status <- Reports.report_status(report) do
      render(conn, "show.html",
        report: report,
        search_results: search_results_with_index,
        total_keyword_count: total_keyword_count,
        total_searched_keyword_count: total_searched_keyword_count,
        total_top_advertisers_count: total_top_advertisers_count,
        status: report_status
      )
    else
      {:error, :not_found} ->
        ErrorHandler.render_error(conn, 404)
    end
  end

  defp replace_path_info_to_dashboard(conn) do
    %{conn | path_info: "dashboard"}
  end
end
