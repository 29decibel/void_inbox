# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VoidInbox.Repo.insert!(%VoidInbox.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# create some dummy email for testing
user = VoidInbox.Accounts.get_user_by_email("m@idots.me")

VoidInbox.VoidEmails.create_void_email(%{
  name: "you",
  user_id: user.id
})
