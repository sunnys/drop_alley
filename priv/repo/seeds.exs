# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DropAlley.Repo.insert!(%DropAlley.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

DropAlley.Repo.delete_all DropAlley.Coherence.User

DropAlley.Coherence.User.changeset(%DropAlley.Coherence.User{}, %{name: "Test User", email: "testuser@example.com", password: "secret", password_confirmation: "secret"})
|> DropAlley.Repo.insert!
|> Coherence.ControllerHelpers.confirm!
