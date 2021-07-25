defmodule CoreBankApi.Users.Create do
  @moduledoc """
  This module is responsible for creating the user

  This can be used as:

      alias CoreBankApi.Users.Create
      params = %{
        name: "Teste",
        age: 23,
        email: "teste@teste.com",
        password: "123456"
      }
      Create.call(params)
  """
  alias CoreBankApi.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, %{status: :bad_request, result: result}}
  end
end
