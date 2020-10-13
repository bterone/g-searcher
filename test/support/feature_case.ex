defmodule GSearcherWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import GSearcher.Factory

      alias GSearcherWeb.Router.Helpers, as: Routes
    end
  end
end
