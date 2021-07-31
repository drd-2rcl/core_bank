defmodule CoreBankApi.WithdrawTest do
  use CoreBankApi.DataCase, async: true

  import CoreBankApi.Factory

  alias CoreBankApi.Withdraw
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      withdraw = build(:withdraw_params)
      params = %{"account_id" => withdraw["id"], "amount" => withdraw["value"]}

      response = Withdraw.changeset(params)

      assert %Changeset{
               changes: %{
                 account_id: "41ac7822-5f62-4d49-b124-fe8db9a85dff",
                 amount: _
               },
               valid?: true
             } = response
    end

    test "when there are some error, returns an invalid changeset with info error" do
      params = build(:withdraw_params, %{"account_id" => "", "amount" => ""})

      response = Withdraw.changeset(params)

      expected_response = %{
        account_id: ["can't be blank"],
        amount: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
