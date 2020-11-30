defmodule GSearcher.Reports do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias GSearcher.Repo
  alias GSearcher.Search
  alias GSearcher.Search.{Report, SearchResult}

  NimbleCSV.define(CSVParser, separator: "\t", escape: "\"")

  def generate_report(user_id, title, file_path) do
    Multi.new()
    |> Multi.insert(
      :report,
      Report.changeset(%{title: title, csv_path: file_path, user_id: user_id})
    )
    |> Multi.run(:search_keywords, fn _, %{report: %{id: report_id, csv_path: csv_path}} ->
      save_keywords_from_file(csv_path, report_id)
    end)
    |> Repo.transaction()

    {:ok, "report"}
  end

  defp save_keywords_from_file(csv_path, report_id) do
    csv_path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSVParser.parse_stream()
    |> Stream.map(fn [search_term] ->
      {:ok, %{id: keyword_id}} = Search.create_search_result(%{search_term: search_term})

      Search.associate_search_result_to_report(%{
        report_id: report_id,
        search_result_id: keyword_id
      })
    end)
    |> Stream.run()

    {:ok, :stuff_inserted}
  end
end
