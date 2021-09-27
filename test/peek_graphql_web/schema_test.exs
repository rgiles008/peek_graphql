defmodule PeekGraphqlWeb.SchemaTest do
  use PeekGraphqlWeb.ConnCase, async: true
  alias PeekGraphql.Accounts.Order
  alias Support.PeekGraphqlFactories, as: Factory

  describe "Orders Query" do
    test "fetch_all_orders should return a list of Orders", %{conn: conn} do
      %Order{id: id} = Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0
      })

      query = """
        query {
          fetchAllOrders{
            id
            description
            total
            balanceDue
            paymentsApplied
            payments{
              id
              amount
              appliedAt
              note
            }
          }
        }
      """

      orders_response = %{
        "data" => %{
          "fetchAllOrders" => [
            %{
              "balanceDue" => 100,
              "description" => "some test",
              "id" => id,
              "payments" => [],
              "paymentsApplied" => 0,
              "total" => 100
            }
          ]
        }
      }

      query =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert query == orders_response
    end
  end

  describe "Orders Mutation" do
    test "create_order should create an order", %{conn: conn} do
      mutation = """
        mutation createOrder($description: String!, $total: Int!){
          createOrder(description: $description, total: $total){
            description
            total
            balanceDue
            paymentsApplied
          }
        }
      """

      variables = %{
        description: "Test Product",
        total: 100
      }

      mutation =
        conn
        |> post("/graphql", %{query: mutation, variables: variables})
        |> json_response(200)

        assert mutation == %{
          "data" => %{
            "createOrder" => %{
              "balanceDue" => 100,
              "description" => "Test Product",
              "paymentsApplied" => 0,
              "total" => 100
            }
          }
        }
    end

    test "create_order should return errors with missing args", %{conn: conn} do
      mutation = """
        mutation createOrder($description: String!, $total: Int!){
          createOrder(description: $description, total: $total){
            description
            total
            balanceDue
            paymentsApplied
          }
        }
      """

      variables = %{
        total: 100
      }

      mutation =
        conn
        |> post("/graphql", %{query: mutation, variables: variables})
        |> json_response(200)

        assert %{"errors" => [_err, _errors]} = mutation
    end

    test "make a payment toward an order", %{conn: conn} do
      order = Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0
      })

      mutation = """
        mutation makePayment($amount: Int!, $note: String, $orderId: UUID){
          makePayment(amount: $amount, note: $note, orderId: $orderId){
            amount
            note
          }
        }
      """

      variables = %{
        amount: 20,
        note: "first payment",
        orderId: order.id
      }

      mutation =
        conn
        |> post("/graphql", %{query: mutation, variables: variables})
        |> json_response(200)

      assert mutation == %{
        "data" => %{
          "makePayment" => %{
            "amount" => 20,
            "note" => "first payment"
          }
        }
      }
    end

    test "make a payment should return errors with invalid args", %{conn: conn} do
      order = Factory.insert(:order, %{
        description: "some test",
        total: 100,
        balance_due: 100,
        payments_applied: 0
      })

      mutation = """
        mutation makePayment($amount: Int!, $note: String, $orderId: UUID){
          makePayment(amount: $amount, note: $note, orderId: $orderId){
            amount
            note
          }
        }
      """

      variables = %{
        note: "first payment",
        orderId: order.id
      }

      mutation =
        conn
        |> post("/graphql", %{query: mutation, variables: variables})
        |> json_response(200)

      assert %{"errors" => [_errors, _err]} = mutation
    end

    test "place an order and make a payment", %{conn: conn} do
      mutation = """
        mutation placeOrderWithPayment($description: String!, $total: Int!, $amount: Int!, $note: String){
          placeOrderWithPayment(description: $description, total: $total, amount: $amount, note: $note){
            description
            balanceDue
            total
            payments{
              amount
              note
            }
          }
        }
      """

      variables = %{
        description: "Product",
        total: 100,
        amount: 50,
        note: "awesome pay"
      }

      mutation =
        conn
        |> post("/graphql", %{query: mutation, variables: variables})
        |> json_response(200)

        assert mutation == %{
          "data" => %{
            "placeOrderWithPayment" => %{
              "balanceDue" => 50,
              "description" => "Product",
              "payments" => [
                %{
                  "amount" => 50,
                  "note" => "awesome pay"
                  }
                ],
              "total" => 100
            }
          }
        }
      end
  end
end