defmodule GSearcher.Accounts.UserFactory do
  alias GSearcher.Accounts.User

  defmacro __using__(_opts) do
    quote do
      alias GSearcher.Accounts.Password

      def user_factory(attrs) do
        password = attrs[:password] || Faker.Util.format("%6b%3d")

        user = %User{
          username: Faker.Internet.user_name(),
          password: password,
          password_confirmation: password,
          encrypted_password: Password.hash_password(password)
        }

        merge_attributes(user, attrs)
      end
    end
  end
end
