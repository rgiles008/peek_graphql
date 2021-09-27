defmodule PeekGraphql.AccountsTest do
  use PeekGraphql.DataCase

  alias PeekGraphql.Accounts
  alias PeekGraphql.Accounts.Order
  alias Support.PeekGraphqlFactories, as: Factory

  describe "orders" do
    @valid_order_attrs %{balance_due: 100, description: "some description", id: "7488a646-e31f-11e4-aace-600308960662", payments_applied: 0, total: 100}
    @update_order_attrs %{balance_due: 43, description: "some updated description", id: "7488a646-e31f-11e4-aace-600308960668", payments_applied: 43, total: 43}
    @invalid_order_attrs %{balance_due: nil, description: nil, id: nil, payments_applied: nil, total: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_order_attrs)
        |> Accounts.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Accounts.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Accounts.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Accounts.create_order(@valid_order_attrs)
      assert order.balance_due == 100
      assert order.description == "some description"
      assert order.payments_applied == 0
      assert order.total == 100
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_order(@invalid_order_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = Accounts.update_order(order, @update_order_attrs)
      assert order.balance_due == 43
      assert order.description == "some updated description"
      assert order.payments_applied == 43
      assert order.total == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_order(order, @invalid_order_attrs)
      assert order == Accounts.get_order!(order.id)
    end
  end

  describe "payments" do
    alias PeekGraphql.Accounts.Payment

    @valid_attrs %{amount: 20, applied_at: "applied_at", id: "0e799bfd-ba52-4e25-897c-8a5da12dfeca", note: "some note", order_id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{amount: 43, applied_at: "some updated applied_at", id: "7488a646-e31f-11e4-aace-600308960668", note: "some updated note"}
    @invalid_attrs %{amount: nil, applied_at: nil, id: nil, note: nil}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_payment()

      payment
    end

    test "create_payment/1 with valid data creates a payment" do
      Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0,
        id: "7488a646-e31f-11e4-aace-600308960662"
      })
      assert {:ok, %Payment{} = payment} = Accounts.create_payment(@valid_attrs)
      assert payment.amount == 20
      assert payment.applied_at == "applied_at"
      assert payment.note == "some note"
      assert payment.order_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0,
        id: "7488a646-e31f-11e4-aace-600308960662"
      })
      payment = payment_fixture()
      assert {:ok, %Payment{} = payment} = Accounts.update_payment(payment, @update_attrs)
      assert payment.amount == 43
      assert payment.applied_at == "some updated applied_at"
      assert payment.note == "some updated note"
      assert payment.order_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "delete_payment/1 deletes the payment" do
      order = Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0,
        id: "7488a646-e31f-11e4-aace-600308960662"
      })
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Accounts.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_payment!(order, payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0,
        id: "7488a646-e31f-11e4-aace-600308960662"
      })
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Accounts.change_payment(payment)
    end
  end
end
