defmodule GSearcherWeb.API.ReportController do
  use GSearcherWeb, :controller

  alias GSearcher.Reports
  alias GSearcherWeb.ErrorHandler
  alias GSearcherWeb.Validators.API.CreateReportParams
  alias GSearcherWeb.Validators.ParamsValidator

  def create(conn, params) do
    %{id: user_id} = conn.assigns.user

    with {:ok, %{csv: csv}} <-
           ParamsValidator.validate(params, as: CreateReportParams),
         {:ok, _report} <- Reports.create_report(user_id, csv.filename, csv.path) do
      send_resp(conn, :created, "")
    else
      {:error, :invalid_params, %Ecto.Changeset{} = report_changeset} ->
        changeset_errors = ErrorHandler.build_changeset_error_message(report_changeset)

        conn
        |> put_status(:bad_request)
        |> ErrorHandler.render_error_json(:bad_request, changeset_errors)

      {:error, :failed_to_save_keywords} ->
        conn
        |> put_status(:unprocessable_entity)
        |> ErrorHandler.render_error_json(:unprocessable_entity, "Failed to save from file")
    end
  end
end
