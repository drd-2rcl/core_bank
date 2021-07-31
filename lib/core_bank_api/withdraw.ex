defmodule CoreBankApi.Withdraw do
  @moduledoc """
  This module is responsible for validating the parameters needed to create a withdraw

  This can be used as:

      alias CoreBankApi.Withdraw
      params = %{
        account_id: 
        amount: 1000.00,
      }
      Withdraw.changeset(params)
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias CoreBankApi.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:account_id, :amount]

  schema "withdraws" do
    field :amount, :decimal
    belongs_to :account, Account

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
