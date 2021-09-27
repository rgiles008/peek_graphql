defmodule PeekGraphqlWeb.Schema do
  @moduledoc """
  Graphql schema for PeekGraphql API
  """

  use Absinthe.Schema
  alias Absinthe.Schema
  alias PeekGraphqlWeb.Resolver
  import_types(PeekGraphqlWeb.Schema.Types.CustomScalars.UUID)

  query do
    @desc "Fetch all orders"
    field :fetch_all_orders, list_of(:order), resolve: &Resolver.fetch_all_orders/3
  end

  mutation do
    @desc "Create an order"
    field :create_order, :order do
      @desc "Description of the product in the order"
      arg(:description, non_null(:string))

      @desc "Total amount for the product"
      arg(:total, non_null(:integer))

      resolve(&Resolver.create_order/3)
    end

    @desc "Make a payment on an order"
    field :make_payment, :payment do
      @desc "Amount of the payment"
      arg(:amount, non_null(:integer))

      @desc "Note about the order"
      arg(:note, :string)

      @desc "Order ID"
      arg(:order_id, :uuid)

      resolve(&Resolver.make_payment/3)
    end

    @desc "Place an order and make a payment"
    field :place_order_with_payment, :order do
      @desc "Description of the product in the order"
      arg(:description, non_null(:string))

      @desc "Total amount for the product"
      arg(:total, non_null(:integer))

      @desc "Amount of the payment"
      arg(:amount, non_null(:integer))

      @desc "Note about the order"
      arg(:note, :string)

      resolve(&Resolver.place_order_with_payment/3)
    end
  end

  #==========================================
  #         OBJECTS
  #==========================================
  object :order do
    @desc "Unique identifier of type UUID"
    field(:id, :uuid)

    @desc "Description of the product(s) being purchased"
    field(:description, :string)

    @desc "Total value of the order"
    field(:total, :integer)

    @desc "Amount of the total order that is left owed"
    field(:balance_due, :integer)

    @desc "The amount of payments that have been applied to the order"
    field(:payments_applied, :integer)

    @desc "List of payments associated to an order"
    field(:payments, list_of(:payment), resolve: &Resolver.fetch_all_payments/3)
  end

  object :payment do
    @desc "Unique Identifier for a payment"
    field(:id, :uuid)

    @desc "Amount of payment applied"
    field(:amount, :integer)

    @desc "Date of when payment was applied"
    field(:applied_at, :string)

    @desc "A note about the order"
    field(:note, :string)
  end
end