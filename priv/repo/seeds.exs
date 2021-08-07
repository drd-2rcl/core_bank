# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CoreBankApi.Repo.insert!(%CoreBankApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, user1} =
  CoreBankApi.create_user(%{
    name: "Mr Support",
    age: 23,
    email: "support@bank.com",
    password: "123456"
  })

{:ok, user2} =
  CoreBankApi.create_user(%{
    name: "Mr Support 2",
    age: 23,
    email: "support2@bank.com",
    password: "123456"
  })

CoreBankApi.create_transfer(%{
  "from_account" => user1.account.id,
  "to_account" => user2.account.id,
  "value" => "12.35"
})

CoreBankApi.create_transfer(%{
  "from_account" => user1.account.id,
  "to_account" => user2.account.id,
  "value" => "89.24"
})

CoreBankApi.create_transfer(%{
  "from_account" => user1.account.id,
  "to_account" => user2.account.id,
  "value" => "1.63"
})

CoreBankApi.create_transfer(%{
  "from_account" => user2.account.id,
  "to_account" => user1.account.id,
  "value" => "94.49"
})

CoreBankApi.create_transfer(%{
  "from_account" => user2.account.id,
  "to_account" => user1.account.id,
  "value" => "42.65"
})

CoreBankApi.create_transfer(%{
  "from_account" => user2.account.id,
  "to_account" => user1.account.id,
  "value" => "67.02"
})

CoreBankApi.create_withdraw(%{"id" => user1.account.id, "value" => "43.0"})

CoreBankApi.create_withdraw(%{"id" => user1.account.id, "value" => "27.04"})

CoreBankApi.create_withdraw(%{"id" => user1.account.id, "value" => "12.30"})

CoreBankApi.create_withdraw(%{"id" => user2.account.id, "value" => "100.40"})

CoreBankApi.create_withdraw(%{"id" => user2.account.id, "value" => "34.30"})

CoreBankApi.create_withdraw(%{"id" => user2.account.id, "value" => "413.0"})
