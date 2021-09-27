defmodule Support.PeekGraphqlFactories do
  @moduledoc false
  use ExMachina.Ecto, repo: PeekGraphql.Repo


  def order_factory do
    %PeekGraphql.Accounts.Order{
      id: uuid()
    }
  end

  defp uuid do
    sequence(:uuid, &uuid/1)
  end

  defp uuid(index) do
    Ecto.UUID.cast!(<<index::size(128)>>)
  end
end