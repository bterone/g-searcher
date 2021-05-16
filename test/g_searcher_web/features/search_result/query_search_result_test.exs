defmodule GSearcherWeb.SearchResult.QuerySearchResultTest do
  use GSearcherWeb.FeatureCase

  @selectors %{
    search_button: ".app-header__search-button",
    search_input: ".app-header__search-input",
    search_result_list: "li"
  }

  feature "query search results given user has search results", %{session: session} do
    user = insert(:user)
    report = insert(:report, user: user)

    search_result = insert(:search_result)

    _report_search_result =
      insert(:report_search_result, report: report, search_result: search_result)

    session
    |> sign_in_as(user)
    |> visit(Routes.dashboard_path(GSearcherWeb.Endpoint, :index))
    |> fill_in(css(@selectors[:search_input]), with: search_result.search_term)
    |> click(css(@selectors[:search_button]))
    |> assert_has(css(@selectors[:search_result_list], text: search_result.search_term))
  end
end
