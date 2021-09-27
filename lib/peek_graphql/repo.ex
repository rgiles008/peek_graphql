defmodule PeekGraphql.Repo do
  use Ecto.Repo,
    otp_app: :peek_graphql,
    adapter: Ecto.Adapters.Postgres
end
