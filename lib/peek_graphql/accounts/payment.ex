defmodule PeekGraphql.Accounts.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeekGraphql.Accounts.Order

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "payments" do
    field :amount, :integer
    field :applied_at, :string
    field :note, :string
    belongs_to :orders, Order, foreign_key: :order_id, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :applied_at, :note, :order_id])
    |> validate_required([:amount, :applied_at, :note])
    |> unique_constraint([:amount, :order_id, :applied_at])
    |> foreign_key_constraint(:order_id)
  end
end
