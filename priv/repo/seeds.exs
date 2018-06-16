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

###################### Bearer Token ###################
# bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkcm9wX2FsbGV5IiwiZXhwIjoxNTMxNzI3MDQ1LCJpYXQiOjE1MjkxMzUwNDUsImlzcyI6ImRyb3BfYWxsZXkiLCJqdGkiOiJlNzhiODUwMy05MjY4LTQ2ZjctYWI1Yi0zMjg4YTE3NjA4YjAiLCJuYmYiOjE1MjkxMzUwNDQsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.C8rZTu9UeIuVGXbq9SC-ENGg8dvUmv1kZpioilpdudm8XXPhxkeJe2OfD30zDp8ja7pnr3Acx4AWOoG2UFy9Xw
