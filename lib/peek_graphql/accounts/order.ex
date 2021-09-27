defmodule PeekGraphql.Accounts.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeekGraphql.Accounts.Payment

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "orders" do
    field :balance_due, :integer
    field :description, :string
    field :payments_applied, :integer
    field :total, :integer
    has_many :payments, Payment, on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:description, :total, :balance_due, :payments_applied])
    |> cast_assoc(:payments)
    |> validate_required([:description, :total, :balance_due, :payments_applied])
    |> unique_constraint(:id)
  end
end
