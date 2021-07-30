defmodule CoreBankApi.Transfer do
  @moduledoc """
  This module is responsible for validating the parameters needed to create a transfer

  This can be used as:

      alias CoreBankApi.Transfer
      params = %{
        from_account: "5ced2ecb-b184-4bf1-8e5e-0d2cf899ad76",
        to_account: "a9df546c-a02e-4490-b13d-e43a13d76baa",
        amount: 10,
      }
      Transfer.changeset(params)
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:from_account, :to_account, :amount]

  schema "transfers" do
    field :from_account, :string
    field :to_account, :string
    field :amount, :decimal

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
