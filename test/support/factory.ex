defmodule GSearcher.Factory do
  use ExMachina.Ecto, repo: GSearcher.Repo

  use GSearcher.Accounts.UserFactory
  use GSearcher.Search.ReportFactory
  use GSearcher.Search.SearchResultFactory
end
