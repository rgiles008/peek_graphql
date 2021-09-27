defmodule PeekGraphql.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :integer
      add :applied_at, :string
      add :note, :string
      add :order_id, references(:orders, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:payments, [:id, :amount, :order_id, :applied_at], name: :uniq_payment_amount)
  end
end
