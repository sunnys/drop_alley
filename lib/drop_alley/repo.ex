defmodule DropAlley.Repo do
  use Ecto.Repo, 
    otp_app: :drop_alley, 
    adapter: Ecto.Adapters.Postgres
end
