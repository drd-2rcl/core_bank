defmodule CoreBankApiWeb.Api.V1.TransferControllerTest do
  use CoreBankApiWeb.ConnCase, async: true
  import CoreBankApi.Factory
  alias CoreBankApiWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      user1 = insert(:user_without_account)

      user2 =
        insert(:user_without_account, %{
          id: "04130282-f694-4ff7-8586-a8e19c051000",
          email: "user2@teste.com"
        })

      {:ok, token1, _claims} = Guardian.encode_and_sign(user1)
      {:ok, token2, _claims} = Guardian.encode_and_sign(user2)
      conn = put_req_header(conn, "authorization", "Bearer #{token1}")
      conn = put_req_header(conn, "authorization", "Bearer #{token2}")

      {:ok, conn: conn, user1: user1, user2: user2}
    end

    test "when all params are valid, creates the transfer", %{
      conn: conn,
      user1: user1,
      user2: user2
    } do
      from_account =
        insert(:account, %{
          id: "1553c177-ba55-46cc-8f0b-78d62fa1e257",
          balance: 100,
          user_id: user1.id
        })

      to_account =
        insert(:account, %{
          id: "88c8e964-fcb9-4238-a475-7b495f9a0ad8",
          balance: 100,
          user_id: user2.id
        })

      params = %{
        "from_account" => "#{from_account.id}",
        "to_account" => "#{to_account.id}",
        "value" => "20.0"
      }

      response =
        conn
        |> post(Routes.transfer_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "Transfer created!",
               "transfer" => %{
                 "amount" => "20.0",
                 "from_account" => "1553c177-ba55-46cc-8f0b-78d62fa1e257",
                 "to_account" => "88c8e964-fcb9-4238-a475-7b495f9a0ad8"
               }
             } = response
    end

    test "when receive invalid value", %{conn: conn, user1: user1, user2: user2} do
      from_account =
        insert(:account, %{
          id: "1553c177-ba55-46cc-8f0b-78d62fa1e257",
          balance: 100,
          user_id: user1.id
        })

      to_account =
        insert(:account, %{
          id: "88c8e964-fcb9-4238-a475-7b495f9a0ad8",
          balance: 100,
          user_id: user2.id
        })

      params = %{
        "from_account" => "#{from_account.id}",
        "to_account" => "#{to_account.id}",
        "value" => "banana"
      }

      response =
        conn
        |> post(Routes.transfer_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid value!"} = response
    end

    test "when receive invalid id", %{conn: conn} do
      params = %{
        "from_account" => "123123123123",
        "to_account" => "123123123123",
        "value" => "20.0"
      }

      response =
        conn
        |> post(Routes.transfer_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"message" => %{"result" => "Invalid ID format!", "status" => "bad_request"}} =
               response
    end

    test "when not found account", %{conn: conn} do
      params = %{
        "from_account" => "04130282-f694-4ff7-8586-a8e19c051000",
        "to_account" => "1553c177-ba55-46cc-8f0b-78d62fa1e257",
        "value" => "20.0"
      }

      response =
        conn
        |> post(Routes.transfer_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"message" => %{"result" => "Account not found!", "status" => "not_found"}} =
               response
    end
  end
end
