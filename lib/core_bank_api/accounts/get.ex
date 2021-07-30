defmodule CoreBankApi.Accounts.Get do
  @moduledoc """
  This module is responsible for validating UUID and get account

  This can be used as:

      alias CoreBankApi.Accounts.Get
      Get.by_id("5ced2ecb-b184-4bf1-8e5e-0d2cf899ad76")
  """
  alias Ecto.UUID
  alias CoreBankApi.{Repo, Account}

  def by_id(id) do
    case UUID.cast(id) do
      :error -> {:error, %{status: :bad_request, result: "Invalid ID format!"}}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Account, uuid) do
      nil -> {:error, %{status: :not_found, result: "Account not found!"}}
      account -> {:ok, account}
    end
  end
end
