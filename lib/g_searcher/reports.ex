defmodule GSearcher.Reports do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias GSearcher.{Repo, SearchResults}
  alias GSearcher.SearchResults.Report

  NimbleCSV.define(CSVParser, separator: "\t", escape: "\"")

  def create_report(user_id, title, file_path) do
    Multi.new()
    |> Multi.insert(
      :report,
      Report.create_changeset(%{title: title, csv_path: file_path, user_id: user_id})
    )
    |> Multi.run(:search_keywords, fn _, %{report: %{id: report_id, csv_path: csv_path}} ->
      save_keywords_from_file(csv_path, report_id)
    end)
    |> Repo.transaction()
    |> handle_report_transaction_response()
  end

  defp save_keywords_from_file(csv_path, report_id) do
    with {:ok, csv_path} <- validate_file_path(csv_path),
         {:ok, file_stream} <- stream_csv(csv_path),
         {:ok, keyword_list} <- save_keywords(file_stream, report_id) do
      # TODO: Rollback only keywords and fail report when making the Report Index
      case Enum.member?(keyword_list, :error) do
        false -> {:ok, keyword_list}
        true -> {:error, :failed_to_save_from_file}
      end
    else
      {:error, :invalid_file_path} -> {:error, :invalid_file_path}
    end
  end

  defp validate_file_path(csv_path) do
    if File.exists?(csv_path) do
      {:ok, csv_path}
    else
      {:error, :invalid_file_path}
    end
  end

  defp stream_csv(csv_path) do
    file_stream =
      csv_path
      |> File.stream!()
      |> CSVParser.parse_stream(skip_headers: false)

    {:ok, file_stream}
  end

  defp save_keywords(file_stream, report_id) do
    keyword_list =
      Stream.map(file_stream, fn [search_term] ->
        create_report_search_result(search_term, report_id)
      end)
      |> Enum.to_list()

    {:ok, keyword_list}
  end

  defp create_report_search_result(search_term, report_id) do
    with {:ok, %{id: keyword_id}} <-
           SearchResults.create_search_result(%{search_term: search_term}),
         {:ok, _report_search_result} <-
           SearchResults.associate_search_result_to_report(report_id, keyword_id) do
      search_term
    else
      {:error, _} -> :error
    end
  end

  defp handle_report_transaction_response(
         {:ok, %{report: report, search_keywords: _search_keywords}}
       ) do
    # TODO: Cast keywords to GenServer

    {:ok, report}
  end

  defp handle_report_transaction_response({:error, _, _, _} = attrs) do
    case attrs do
      {:error, :report, changeset, _} -> {:error, changeset}
      {:error, :search_keywords, _, _} -> {:error, :failed_to_save_keywords}
    end
  end
end
