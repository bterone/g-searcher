defmodule GSearcher.Accounts.Password do
  def hash_password(password), do: Argon2.hash_pwd_salt(password)
end
