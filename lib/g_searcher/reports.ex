defmodule GSearcher.Reports do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias GSearcher.{Repo, SearchResults}
  alias GSearcher.SearchResults.{Report, ReportSearchResult, SearchResult, SearchWorker}

  @completed "Completed"
  @searching "Searching"

  NimbleCSV.define(CSVParser, separator: "\t", escape: "\"")

  def create_report(user_id, title, file_path) do
    Multi.new()
    |> Multi.run(:file_path, fn _, _ -> validate_file_path(file_path) end)
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

  def get_by(params) do
    Report
    |> preload(:search_results)
    |> Repo.get_by(params)
    |> case do
      nil -> {:error, :not_found}
      report -> {:ok, report}
    end
  end

  def list_reports_by_user(user_id) do
    Report
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def total_searched_report_keywords_count(report_id) do
    ReportSearchResult
    |> join(:inner, [rsr], sr in assoc(rsr, :search_result))
    |> where([rsr, sr], rsr.report_id == ^report_id and not is_nil(sr.html_cache))
    |> Repo.aggregate(:count)
  end

  def total_report_keywords_count(report_id) do
    ReportSearchResult
    |> where(report_id: ^report_id)
    |> Repo.aggregate(:count)
  end

  def report_status(report) do
    total_keywords = total_report_keywords_count(report.id)
    total_searched_keywords = total_searched_report_keywords_count(report.id)

    cond do
      total_searched_keywords < total_keywords -> @searching
      total_searched_keywords == total_keywords -> @completed
    end
  end

  def total_top_advertisers_count(report_id) do
    SearchResult
    |> join(:inner, [sr], rsr in assoc(sr, :report_search_result))
    |> where([sr, rsr], rsr.report_id == ^report_id and not is_nil(sr.html_cache))
    |> select([sr], sum(sr.number_of_top_advertisers))
    |> Repo.one()
  end

  defp save_keywords_from_file(csv_path, report_id) do
    with {:ok, file_stream} <- stream_csv(csv_path),
         {:ok, keyword_list} <- save_keywords(file_stream, report_id) do
      # TODO: Rollback only keywords and fail report when making the Report Index
      case Enum.member?(keyword_list, :error) do
        false -> {:ok, keyword_list}
        true -> {:error, :failed_to_save_from_file}
      end
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
      {keyword_id, search_term}
    else
      {:error, _} -> :error
    end
  end

  defp handle_report_transaction_response(
         {:ok, %{report: report, search_keywords: search_keywords}}
       ) do
    search_keywords
    |> Enum.each(fn {keyword_id, search_term} ->
      SearchWorker.new(%{id: keyword_id, keyword: search_term})
      |> Oban.insert()
    end)

    {:ok, report}
  end

  defp handle_report_transaction_response({:error, _, _, _} = attrs) do
    case attrs do
      {:error, :file_path, :invalid_file_path, _} -> {:error, :failed_to_save_keywords}
      {:error, :report, changeset, _} -> {:error, :invalid_params, changeset}
      {:error, :search_keywords, _, _} -> {:error, :failed_to_save_keywords}
    end
  end
end
