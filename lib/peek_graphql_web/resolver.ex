defmodule PeekGraphqlWeb.Resolver do
  @moduledoc """
  Resolver for Order queries and mutations
  """

  alias PeekGraphql.Accounts

  @spec fetch_all_orders(map(), map(), map()) :: {:ok, [map()]}
  def fetch_all_orders(_parent, _args, _resolution) do
    {:ok, Accounts.list_orders()}
  end

  @spec fetch_all_payments(map(), map(), map()) :: {:ok, [map()]}
  def fetch_all_payments(_parent, _args, _resolution) do
    {:ok, Accounts.list_payments()}
  end

  @spec create_order(map(), map(), map()) :: {:ok, %PeekGraphql.Accounts.Order{}} | {:error, %Ecto.Changeset{}}
  def create_order(_parent, %{description: description, total: total}, _res) do
    new_order_params = %{
      description: description,
      total: total,
      balance_due: total,
      payments_applied: 0
    }

    Accounts.create_order(new_order_params)
  end

  @spec make_payment(map(), map(), map()) :: {:ok, map()} | {:error, %Ecto.Changeset{}}
  def make_payment(_parent, %{amount: amount, note: note, order_id: id}, _res) do
    payment_params = %{
      amount: amount,
      applied_at: DateTime.utc_now |> to_string(),
      note: note,
      order_id: id
    }

    update_order_status(amount, id)

    Accounts.create_payment(payment_params)
  end

  @spec place_order_with_payment(map(), map(), map()) :: {:ok, map()} | {:error, String.t()}
  def place_order_with_payment(_parent, args, _resolution) do
    Accounts.create_order_with_payment(args)
  end

  def update_order_status(amount, id) do
    order = Accounts.get_order!(id)

    reconciled_order =
      order
      |> Map.put(:balance_due, order.balance_due - amount)
      |> Map.put(:payments_applied, order.payments_applied + 1)
      |> Map.from_struct()

    Accounts.update_order(order, reconciled_order)
  end
end