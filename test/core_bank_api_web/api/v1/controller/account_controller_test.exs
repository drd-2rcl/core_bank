defmodule CoreBankApiWeb.Api.V1.AccountControllerTest do
  use CoreBankApiWeb.ConnCase, async: true
  import CoreBankApi.Factory
  alias CoreBankApiWeb.Auth.Guardian

  describe "withdraw/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when all params are valid, creates the withdraw", %{conn: conn, user: user} do
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

    test "when receive invalid value", %{conn: conn, user: user} do
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

  describe "export/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when all params are valid, export the report", %{conn: conn, user: user} do
      account = insert(:account, %{user_id: user.id, balance: 100})

      insert(:financial_transaction, %{
        account_id: account.id,
        date: Date.utc_today(),
        value: "32.94",
        id: "afa26b99-3cf1-460b-9871-7bd3d768b9b4"
      })

      response =
        conn
        |> get(Routes.account_path(conn, :export, account.id))

      assert "R$ Entrada/dia,R$ Sa??da/dia,R$ Entrada/m??s,R$ Sa??da/m??s,R$ Entrada/ano,R$ Sa??da/ano\r\n32.94,,32.94,,32.94,\r\n" =
               response.resp_body

      assert 200 = response.status
    end
  end
end
