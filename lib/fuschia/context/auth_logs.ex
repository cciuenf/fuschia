defmodule Fuschia.Context.AuthLogs do
  @moduledoc """
  Public Fuschia Authentication Logs API
  """

  alias Fuschia.Entities.{AuthLog, User}
  alias Fuschia.Repo

  @spec create(map) :: :ok
  def create(attrs) do
    %AuthLog{}
    |> AuthLog.changeset(attrs)
    |> Repo.insert()

    :ok
  end

  @spec create(String.t(), String.t(), User.t()) :: :ok
  def create(ip, user_agent, user) do
    user_cpf = Map.get(user, :cpf) || Map.get(user, "cpf")
    create(%{"ip" => ip, "user_agent" => user_agent, "user_cpf" => user_cpf})
  end
end
