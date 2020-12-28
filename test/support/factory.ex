defmodule GSearcher.Factory do
  use ExMachina.Ecto, repo: GSearcher.Repo

  use GSearcher.Accounts.UserFactory
  use GSearcher.SearchResults.ReportFactory
  use GSearcher.SearchResults.SearchResultFactory
end
