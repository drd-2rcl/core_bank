defmodule CoreBankApi.TransferTest do
  use CoreBankApi.DataCase, async: true

  import CoreBankApi.Factory

  alias CoreBankApi.Transfer
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:transfer_params)

      response = Transfer.changeset(params)

      assert %Changeset{
               changes: %{
                 amount: _,
                 from_account: "5ced2ecb-b184-4bf1-8e5e-0d2cf899ad76",
                 to_account: "a9df546c-a02e-4490-b13d-e43a13d76baa"
               },
               valid?: true
             } = response
    end

    test "when there are some error, returns an invalid changeset with info error" do
      params =
        build(:transfer_params, %{"from_account" => "", "to_account" => "", "amount" => ""})

      response = Transfer.changeset(params)

      expected_response = %{
        from_account: ["can't be blank"],
        to_account: ["can't be blank"],
        amount: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
