defmodule DropAlleyWeb.UserIdentityControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Account

  @create_attrs %{provider: "some provider", uid: "some uid", user_id: 42}
  @update_attrs %{provider: "some updated provider", uid: "some updated uid", user_id: 43}
  @invalid_attrs %{provider: nil, uid: nil, user_id: nil}

  def fixture(:user_identity) do
    {:ok, user_identity} = Account.create_user_identity(@create_attrs)
    user_identity
  end

  describe "index" do
    test "lists all user_identities", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :index)
      assert html_response(conn, 200) =~ "User identities"
    end
  end

  describe "new user_identity" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :new)
      assert html_response(conn, 200) =~ "New User identity"
    end
  end

  describe "create user_identity" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :create), user_identity: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, id)
      assert html_response(conn, 200) =~ "User identity Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :create), user_identity: @invalid_attrs
      assert html_response(conn, 200) =~ "New User identity"
    end
  end

  describe "edit user_identity" do
    setup [:create_user_identity]

    test "renders form for editing chosen user_identity", %{conn: conn, user_identity: user_identity} do
      conn = get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :edit, user_identity)
      assert html_response(conn, 200) =~ "Edit User identity"
    end
  end

  describe "update user_identity" do
    setup [:create_user_identity]

    test "redirects when data is valid", %{conn: conn, user_identity: user_identity} do
      conn = put conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :update, user_identity), user_identity: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, user_identity)

      conn = get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, user_identity)
      assert html_response(conn, 200) =~ "some updated provider"
    end

    test "renders errors when data is invalid", %{conn: conn, user_identity: user_identity} do
      conn = put conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :update, user_identity), user_identity: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User identity"
    end
  end

  describe "delete user_identity" do
    setup [:create_user_identity]

    test "deletes chosen user_identity", %{conn: conn, user_identity: user_identity} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :delete, user_identity)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.user_identity_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.user_identity_path(conn, :show, user_identity)
      end
    end
  end

  defp create_user_identity(_) do
    user_identity = fixture(:user_identity)
    {:ok, user_identity: user_identity}
  end
end
