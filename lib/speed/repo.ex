defmodule Speed.Repo do
  use Ecto.Repo,
    otp_app: :speed,
    adapter: Ecto.Adapters.SQLite3
end
