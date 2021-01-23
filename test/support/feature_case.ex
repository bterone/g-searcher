defmodule GSearcherWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import Wallaby.Query
      import GSearcher.Factory

      alias GSearcherWeb.Router.Helpers, as: Routes

      def sign_in_as(session, user) do
        session
        |> visit("/test_auth/test_provider/callback?sign_in_as=#{user.email}")
      end
    end
  end
end
