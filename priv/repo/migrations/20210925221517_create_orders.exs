defmodule PeekGraphql.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :description, :string
      add :total, :integer
      add :balance_due, :integer
      add :payments_applied, :integer

      timestamps()
    end

    create unique_index(:orders, [:id])
  end
end
