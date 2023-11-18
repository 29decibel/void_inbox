defmodule VoidInbox.Repo do
  use Ecto.Repo,
    otp_app: :void_inbox,
    adapter: Ecto.Adapters.Postgres
end
