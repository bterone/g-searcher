defmodule GSearcher.SearchResults.SearchWorkerTest do
  use GSearcher.DataCase, async: true
  use Oban.Testing, repo: GSearcher.Repo

  alias GSearcher.{Repo, SearchResults}
  alias GSearcher.SearchResults.{SearchResult, SearchResultURL, SearchWorker}

  describe "perform/1" do
    test "updates search_result after successfully searching keyword" do
      use_cassette "search_keyword_successfully" do
        search_result = insert(:only_search_term)

        SearchWorker.new(%{id: search_result.id, keyword: search_result.search_term})
        |> Oban.insert()

        assert Oban.drain_queue(queue: :events, with_safety: false) == %{success: 1, failure: 0}

        [search_result_in_db] = Repo.all(SearchResult)
        assert search_result_in_db.id == search_result.id
        assert search_result_in_db.html_cache

        assert Repo.all(SearchResultURL) != []
      end
    end

    test "fails job if HTTP client fails to search keyword" do
      search_result = insert(:only_search_term)

      stub(HTTPoison, :get, fn _, _ -> {:error, %{reason: :econnrefused}} end)

      SearchWorker.new(%{id: search_result.id, keyword: search_result.search_term})
      |> Oban.insert()

      assert Oban.drain_queue(queue: :events) == %{success: 0, failure: 1}
    end

    test "fails job if search result fails to update" do
      use_cassette "search_keyword_successfully" do
        search_result = insert(:only_search_term)

        expect(SearchResults, :update_search_result, fn _, _ ->
          {:error, %Ecto.Changeset{valid?: false}}
        end)

        SearchWorker.new(%{id: search_result.id, keyword: search_result.search_term})
        |> Oban.insert()

        assert Oban.drain_queue(queue: :events) == %{success: 0, failure: 1}

        verify!()
      end
    end

    test "fails job if search result is not found" do
      reject(HTTPoison, :get, 2)

      SearchWorker.new(%{id: 0, keyword: "SOMETHING RANDOM"})
      |> Oban.insert()

      assert Oban.drain_queue(queue: :events) == %{success: 0, failure: 1}

      verify!()
    end
  end
end
