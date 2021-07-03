defmodule GSearcherWeb.API.SearchResultControllerTest do
  use GSearcherWeb.APICase, async: true

  describe "index/2" do
    test "returns search results belonging to the user given no params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result_1 = insert(:search_result, total_number_of_results: 1_000_000)
      search_result_2 = insert(:search_result, total_number_of_results: 1_500_000)

      _report_search_result_1 =
        insert(:report_search_result, report: report, search_result: search_result_1)

      _report_search_result_2 =
        insert(:report_search_result, report: report, search_result: search_result_2)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :index))

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "type" => "search_result",
                   "id" => search_result_1.id,
                   "attributes" => %{
                     "keyword" => search_result_1.search_term,
                     "status" => "Completed",
                     "top_advertiser_count" => search_result_1.number_of_top_advertisers,
                     "regular_advertiser_count" => search_result_1.number_of_regular_advertisers,
                     "page_result_count" => search_result_1.number_of_results_on_page,
                     "total_result_count" => "1 Million"
                   }
                 },
                 %{
                   "type" => "search_result",
                   "id" => search_result_2.id,
                   "attributes" => %{
                     "keyword" => search_result_2.search_term,
                     "status" => "Completed",
                     "top_advertiser_count" => search_result_2.number_of_top_advertisers,
                     "regular_advertiser_count" => search_result_2.number_of_regular_advertisers,
                     "page_result_count" => search_result_2.number_of_results_on_page,
                     "total_result_count" => "1.5 Million"
                   }
                 }
               ]
             }
    end

    test "returns search results belonging to user given valid params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result =
        insert(:search_result, total_number_of_results: 1_000_000, search_term: "Boba Tea")

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :index), %{query: "Tea"})

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "type" => "search_result",
                   "id" => search_result.id,
                   "attributes" => %{
                     "keyword" => search_result.search_term,
                     "status" => "Completed",
                     "top_advertiser_count" => search_result.number_of_top_advertisers,
                     "regular_advertiser_count" => search_result.number_of_regular_advertisers,
                     "page_result_count" => search_result.number_of_results_on_page,
                     "total_result_count" => "1 Million"
                   }
                 }
               ]
             }
    end

    test "returns no search results given the user has NO search results", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :index))

      assert json_response(conn, 200) == %{"data" => []}
    end

    test "renders search results belonging to user given invalid params", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result =
        insert(:search_result, total_number_of_results: 1_000_000, search_term: "Boba Tea")

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :index), %{
          query: "Tea",
          top_ads: "Boba Tea"
        })

      assert json_response(conn, 400) == %{
               "errors" => [
                 %{
                   "detail" => "top_ads operation should only be '<, >, ='",
                   "status" => "bad_request"
                 }
               ]
             }
    end
  end

  describe "show/2" do
    test "returns search result urls given a search result", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result = insert(:search_result, total_number_of_results: 1_000_000)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      search_result_url_1 = insert(:search_result_url, search_result: search_result)
      search_result_url_2 = insert(:search_result_url, search_result: search_result)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :show, search_result.id))

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "type" => "search_result_url",
                   "id" => search_result_url_1.id,
                   "attributes" => %{
                     "title" => search_result_url_1.title,
                     "url" => search_result_url_1.url,
                     "is_top_ad" => search_result_url_1.is_top_ad,
                     "is_regular_ad" => search_result_url_1.is_regular_ad
                   }
                 },
                 %{
                   "type" => "search_result_url",
                   "id" => search_result_url_2.id,
                   "attributes" => %{
                     "title" => search_result_url_2.title,
                     "url" => search_result_url_2.url,
                     "is_top_ad" => search_result_url_2.is_top_ad,
                     "is_regular_ad" => search_result_url_2.is_regular_ad
                   }
                 }
               ],
               "included" => %{
                 "type" => "search_result",
                 "id" => search_result.id,
                 "attributes" => %{
                   "keyword" => search_result.search_term,
                   "status" => "Completed",
                   "top_advertiser_count" => search_result.number_of_top_advertisers,
                   "regular_advertiser_count" => search_result.number_of_regular_advertisers,
                   "page_result_count" => search_result.number_of_results_on_page,
                   "total_result_count" => "1 Million"
                 }
               }
             }
    end

    test "returns no search result urls given a search result has no urls", %{conn: conn} do
      user = insert(:user)
      report = insert(:report, user: user)

      search_result =
        insert(:search_result, search_result_urls: [], total_number_of_results: 1_000_000)

      _report_search_result =
        insert(:report_search_result, report: report, search_result: search_result)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :show, search_result.id))

      assert json_response(conn, 200) == %{
               "data" => [],
               "included" => %{
                 "type" => "search_result",
                 "id" => search_result.id,
                 "attributes" => %{
                   "keyword" => search_result.search_term,
                   "status" => "Completed",
                   "top_advertiser_count" => search_result.number_of_top_advertisers,
                   "regular_advertiser_count" => search_result.number_of_regular_advertisers,
                   "page_result_count" => search_result.number_of_results_on_page,
                   "total_result_count" => "1 Million"
                 }
               }
             }
    end

    test "returns a 404 error response given a non-existing search_result ID", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authenticate_user(user)
        |> get(APIRoutes.api_search_result_path(conn, :show, 0))

      assert json_response(conn, 404) == %{
               "errors" => [
                 %{
                   "detail" => "Not found",
                   "status" => "not_found"
                 }
               ]
             }
    end
  end
end
