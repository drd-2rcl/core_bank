defmodule CoreBankApiWeb.Api.V1.AccountControllerTest do
  use CoreBankApiWeb.ConnCase, async: true

  import CoreBankApi.Factory

  describe "withdraw/2" do
    test "when all params are valid, creates the withdraw", %{conn: conn} do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id, balance: 100})

      response =
        conn
        |> post(Routes.account_path(conn, :withdraw, account.id, %{"value" => "10.0"}))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "balance" => "R$ 90.0",
                 "id" => "8ce40338-521f-4f6a-9c0e-a9022e81655e"
               },
               "message" => "Successful withdrawal!"
             } = response
    end

    test "when receive invalid value", %{conn: conn} do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id, balance: 100})

      response =
        conn
        |> post(Routes.account_path(conn, :withdraw, account.id, %{"value" => "banana"}))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid value!"} = response
    end

    test "when not found account", %{conn: conn} do
      response =
        conn
        |> post(
          Routes.account_path(conn, :withdraw, "8ce40338-521f-4f6a-9c0e-a9022e81655e", %{
            "value" => "20.0"
          })
        )
        |> json_response(:not_found)

      assert %{"message" => "Account not found!"} = response
    end

    test "when receive invalid ID", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :withdraw, "12313123123", %{"value" => "20.0"}))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid ID format!"} = response
    end
  end
end
