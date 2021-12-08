defmodule FuschiaWeb.Auth.Guardian do
  @moduledoc """
  Guardian serializer for Fuschia app
  """

  use Guardian, otp_app: :fuschia

  alias Fuschia.Context.Users
  alias Fuschia.Entities.User

  @spec subject_for_token(User.t(), map) :: {:ok, String.t()}
  def subject_for_token(user, _claims) do
    sub = to_string(user.cpf)

    {:ok, sub}
  end

  @spec resource_from_claims(map) :: {:ok, %User{}} | {:error, nil}
  def resource_from_claims(claims) do
    user =
      claims
      |> Map.get("sub")
      |> Users.one()

    {:ok, user}
  end

  @spec authenticate(map) :: {:ok, String.t()} | {:error, :unauthorized}
  def authenticate(%{"cpf" => cpf, "password" => password}) do
    case Users.one_by_cpf(cpf) do
      nil -> {:error, :unauthorized}
      user -> validate_password(user, password)
    end
  end

  @spec user_claims(map) :: {:ok, User.t()} | {:error, :unauthorized}
  def user_claims(%{"cpf" => cpf}) do
    case Users.one_with_permissions(cpf) do
      nil -> {:error, :unauthorized}
      user -> {:ok, User.for_jwt(user)}
    end
  end

  @spec create_token(User.t()) :: {:ok, String.t()}
  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)

    {:ok, token}
  end

  @spec validate_password(User.t(), String.t()) :: {:ok, String.t()} | {:error, :unauthorized}
  defp validate_password(_user, ""), do: {:error, :unauthorized}

  defp validate_password(user, password) when is_binary(password) do
    with %User{password_hash: password_hash} = user <- user,
         false <- is_nil(password_hash),
         true <- Bcrypt.verify_pass(password, user.password_hash) do
      create_token(user)
    else
      _invalid_password -> {:error, :unauthorized}
    end
  end

  defp validate_password(_user, _password), do: {:error, :unauthorized}
end
