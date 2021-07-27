defmodule CoreBankApi.AccountTest do
  use CoreBankApi.DataCase, async: true

  import CoreBankApi.Factory

  alias CoreBankApi.Account
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      user = build(:user)
      params = build(:account_params, %{"user_id" => user.id})

      response = Account.changeset(params)

      assert %Changeset{changes: %{balance: _, user_id: _}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset with info error" do
      params = build(:account_params)

      response = Account.changeset(params)

      expected_response = %{
        user_id: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
