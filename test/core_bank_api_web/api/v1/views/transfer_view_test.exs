defmodule CoreBankApiWeb.Api.V1.TransferViewTest do
  use CoreBankApiWeb.ConnCase, async: true

  import Phoenix.View
  import CoreBankApi.Factory

  alias CoreBankApiWeb.Api.V1.TransferView

  test "renders create.json" do
    transfer = build(:transfer)

    response =
      render(TransferView, "create.json", %{
        transfer: transfer
      })

    assert %{
             message: "Transfer created!",
             transfer: %{
               amount: "50.0",
               from_account: "14316760-26ee-43c3-858c-c331a8da40a5",
               to_account: "d3fe719d-6fe4-4e4e-abc6-42c8dcf992fc"
             }
           } = response
  end
end
