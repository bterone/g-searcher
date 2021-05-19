defmodule GSearcher.Factory do
  use ExMachina.Ecto, repo: GSearcher.Repo

  use GSearcher.Accounts.UserFactory

  use GSearcher.SearchResults.{
    ReportFactory,
    ReportSearchResultFactory,
    SearchResultFactory,
    SearchResultURLFactory
  }
end
