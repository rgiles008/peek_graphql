# PeekGraphql

[Instructions](https://gist.github.com/thonydam/3010cb99a8925f7206459db42c776718)

## Tasks Implemented
- Query to fetch all orders -> Complete
- Mutation to create an order -> Complete
- Mutation to apply a payment to an order -> Complete

***Extras***
- Not exposing auto incrementing ID's -> Complete
- Idempotent mutations -> Complete
- Place order and pay mutation -> Complete

## Getting Up and Running
You will need elixir and erlang installed to run this API.
> Elixir version 1.12.2 and Erland 24.0.4 were used here

1. Run `mix deps.get`
2. Run `mix ecto.create && mix ecto.migrate`
3. Run `mix priv/repo/seeds.exs`
> You should have a few items as seeds to work with
4. Run `mix phx.server`
5. Go to `http://localhost:4000/api/graphiql`
6. Run some queries and mutations such as:
```
# query

  {
    fetchAllOrders{
      id
      description
      total
      balanceDue
      paymentsApplied
      payments
    }
  }
```

```
> You will need to save the ID from this mutation to use the `make_payment` mutation

  mutation {
    createOrder(description: "Some Test", total: 100){
      id
      description
      total
      balanceDue
      paymentsApplied
      payments
    }
  }
```

```
  mutation makePayment($amount: Int!, $note: String, $orderId: Int){
    makePayment(amount: $amount, note: $note, orderId: $orderId){
      id
      amount
      note
      appliedAt
      orderId
    }
  }

  variables: {
    "amount": 25,
    "note": "test note",
    "orderId": <input ID from createOrder mutation>
  }
```

### Dev Notes

I had a pagerduty event that occured over the weekend and is still happening but I was able to step away for an hour or so to get this done. I hope it covers the task and shows the knowledge needed to move forward. 
