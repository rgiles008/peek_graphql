# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PeekGraphql.Repo.insert!(%PeekGraphql.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias PeekGraphql.Accounts.{Order, Payment}
alias PeekGraphql.Repo

orders = [
  %{
    id: "dd9971ba-eb05-41c6-95a6-c38c39b2ec50"
    description: "Item 1",
    total: 100,
    payments_applied: 2,
    balance_due: 50,
    payments: [
     %{
        amount: 20,
        applied_at: "2021-09-25 22:56:33.574000Z",
        note: "Some note",
        order_id: "dd9971ba-eb05-41c6-95a6-c38c39b2ec50"
      },
      %{
        amount: 30,
        applied_at: "2021-09-24 22:56:33.574000Z",
        note: "Some note",
        order_id: "dd9971ba-eb05-41c6-95a6-c38c39b2ec50"
      }
    ]
  }
]

Enum.each(orders, fn order ->
  Order.create_order(order)
end)