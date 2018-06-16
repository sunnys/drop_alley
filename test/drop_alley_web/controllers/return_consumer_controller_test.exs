defmodule DropAlleyWeb.ReturnConsumerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store

  @create_attrs %{active: true}
  @update_attrs %{active: false}
  @invalid_attrs %{active: nil}

  def fixture(:return_consumer) do
    {:ok, return_consumer} = Store.create_return_consumer(@create_attrs)
    return_consumer
  end

  describe "index" do
    test "lists all return_consumers", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :index)
      assert html_response(conn, 200) =~ "Return consumers"
    end
  end

  describe "new return_consumer" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Return consumer"
    end
  end

  describe "create return_consumer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :create), return_consumer: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Return consumer Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :create), return_consumer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Return consumer"
    end
  end

  describe "edit return_consumer" do
    setup [:create_return_consumer]

    test "renders form for editing chosen return_consumer", %{conn: conn, return_consumer: return_consumer} do
      conn = get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :edit, return_consumer)
      assert html_response(conn, 200) =~ "Edit Return consumer"
    end
  end

  describe "update return_consumer" do
    setup [:create_return_consumer]

    test "redirects when data is valid", %{conn: conn, return_consumer: return_consumer} do
      conn = put conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :update, return_consumer), return_consumer: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, return_consumer)

      conn = get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, return_consumer)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, return_consumer: return_consumer} do
      conn = put conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :update, return_consumer), return_consumer: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Return consumer"
    end
  end

  describe "delete return_consumer" do
    setup [:create_return_consumer]

    test "deletes chosen return_consumer", %{conn: conn, return_consumer: return_consumer} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :delete, return_consumer)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, return_consumer)
      end
    end
  end

  defp create_return_consumer(_) do
    return_consumer = fixture(:return_consumer)
    {:ok, return_consumer: return_consumer}
  end
end
