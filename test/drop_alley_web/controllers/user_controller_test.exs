defmodule DropAlleyWeb.UserControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Account

  @create_attrs %{confirmation_sent_at: "2010-04-17 14:00:00.000000Z", confirmation_token: "some confirmation_token", confirmed_at: "2010-04-17 14:00:00.000000Z", current_sign_in_at: "2010-04-17 14:00:00.000000Z", current_sign_in_ip: "some current_sign_in_ip", email: "some email", failed_attempts: 42, last_sign_in_at: "2010-04-17 14:00:00.000000Z", last_sign_in_ip: "some last_sign_in_ip", locked_at: "2010-04-17 14:00:00.000000Z", name: "some name", password_hash: "some password_hash", reset_password_sent_at: "2010-04-17 14:00:00.000000Z", reset_password_token: "some reset_password_token", sign_in_count: 42, unlock_token: "some unlock_token"}
  @update_attrs %{confirmation_sent_at: "2011-05-18 15:01:01.000000Z", confirmation_token: "some updated confirmation_token", confirmed_at: "2011-05-18 15:01:01.000000Z", current_sign_in_at: "2011-05-18 15:01:01.000000Z", current_sign_in_ip: "some updated current_sign_in_ip", email: "some updated email", failed_attempts: 43, last_sign_in_at: "2011-05-18 15:01:01.000000Z", last_sign_in_ip: "some updated last_sign_in_ip", locked_at: "2011-05-18 15:01:01.000000Z", name: "some updated name", password_hash: "some updated password_hash", reset_password_sent_at: "2011-05-18 15:01:01.000000Z", reset_password_token: "some updated reset_password_token", sign_in_count: 43, unlock_token: "some updated unlock_token"}
  @invalid_attrs %{confirmation_sent_at: nil, confirmation_token: nil, confirmed_at: nil, current_sign_in_at: nil, current_sign_in_ip: nil, email: nil, failed_attempts: nil, last_sign_in_at: nil, last_sign_in_ip: nil, locked_at: nil, name: nil, password_hash: nil, reset_password_sent_at: nil, reset_password_token: nil, sign_in_count: nil, unlock_token: nil}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :index)
      assert html_response(conn, 200) =~ "Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "User Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, DropAlleyWeb.Router.Helpers.user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_path(conn, :show, user)

      conn = get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated confirmation_token"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, DropAlleyWeb.Router.Helpers.user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.user_path(conn, :delete, user)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
