defmodule GSearcher.Accounts.UserFactory do
  alias GSearcher.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory(attrs) do
        user = %User{
          email: Faker.Internet.email(),
          provider: String.downcase(Faker.Person.first_name()),
          token: Faker.String.base64(100)
        }

        merge_attributes(user, attrs)
      end
    end
  end
end
