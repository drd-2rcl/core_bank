defmodule CoreBankApi.Transfers.OperationTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Transfers.Operation
  alias Ecto.Multi

  describe "call/2" do
    test "when the operation is credit" do
      account = build(:account)
      operation_name = fn _repo, _result -> account end
      operation = fn _repo, _result -> account end

      multi =
        Multi.new()
        |> Multi.run(:account_credit, operation_name)
        |> Multi.run(:credit, operation)

      user = insert(:user)
      insert(:account, %{user_id: user.id})

      params = %{
        "id" => "8ae8e363-8dab-477a-9b43-0dc47af8e019",
        "value" => "20.0"
      }

      %Multi{
        names: names,
        operations: _operations_result
      } = Operation.call(params, :credit)

      assert names == MapSet.new([:account_credit, :credit])

      assert [
               credit: {:run, _operation_name},
               account_credit: {:run, _operation}
             ] = multi.operations
    end

    test "when the operation is debit" do
      account = build(:account)
      operation_name = fn _repo, _result -> account end
      operation = fn _repo, _result -> account end

      multi =
        Multi.new()
        |> Multi.run(:account_debit, operation_name)
        |> Multi.run(:debit, operation)

      user = insert(:user)
      insert(:account, %{user_id: user.id})

      params = %{
        "id" => "8ae8e363-8dab-477a-9b43-0dc47af8e019",
        "value" => "20.0"
      }

      %Multi{
        names: names,
        operations: _operations_result
      } = Operation.call(params, :debit)

      assert names == MapSet.new([:account_debit, :debit])

      assert [
               debit: {:run, _operation_name},
               account_debit: {:run, _operation}
             ] = multi.operations
    end
  end
end
