defmodule Washer.Repo do
  use Ecto.Repo,
    otp_app: :washer,
    adapter: Ecto.Adapters.Postgres
end
