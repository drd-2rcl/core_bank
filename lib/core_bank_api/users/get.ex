defmodule CoreBankApi.Users.Get do
  @moduledoc """
  This module is responsible for validating UUID and get user

  This can be used as:

      alias CoreBankApi.Users.Get
      Get.by_id("5ced2ecb-b184-4bf1-8e5e-0d2cf899ad76")
  """
  alias CoreBankApi.{Repo, User}
  alias Ecto.UUID

  def by_id(id) do
    case UUID.cast(id) do
      :error -> {:error, %{status: :bad_request, result: "Invalid ID format!"}}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(User, uuid) do
      nil -> {:error, %{status: :not_found, result: "User not found!"}}
      user -> {:ok, user}
    end
  end
end
