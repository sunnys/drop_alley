defmodule DropAlleyWeb.RetailerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store

  @create_attrs %{active: true, api_key: "some api_key", details: %{}, name: "some name"}
  @update_attrs %{active: false, api_key: "some updated api_key", details: %{}, name: "some updated name"}
  @invalid_attrs %{active: nil, api_key: nil, details: nil, name: nil}

  def fixture(:retailer) do
    {:ok, retailer} = Store.create_retailer(@create_attrs)
    retailer
  end

  describe "index" do
    test "lists all retailers", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :index)
      assert html_response(conn, 200) =~ "Retailers"
    end
  end

  describe "new retailer" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Retailer"
    end
  end

  describe "create retailer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :create), retailer: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Retailer Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :create), retailer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Retailer"
    end
  end

  describe "edit retailer" do
    setup [:create_retailer]

    test "renders form for editing chosen retailer", %{conn: conn, retailer: retailer} do
      conn = get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :edit, retailer)
      assert html_response(conn, 200) =~ "Edit Retailer"
    end
  end

  describe "update retailer" do
    setup [:create_retailer]

    test "redirects when data is valid", %{conn: conn, retailer: retailer} do
      conn = put conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :update, retailer), retailer: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, retailer)

      conn = get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, retailer)
      assert html_response(conn, 200) =~ "some updated api_key"
    end

    test "renders errors when data is invalid", %{conn: conn, retailer: retailer} do
      conn = put conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :update, retailer), retailer: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Retailer"
    end
  end

  describe "delete retailer" do
    setup [:create_retailer]

    test "deletes chosen retailer", %{conn: conn, retailer: retailer} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :delete, retailer)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.retailer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.retailer_path(conn, :show, retailer)
      end
    end
  end

  defp create_retailer(_) do
    retailer = fixture(:retailer)
    {:ok, retailer: retailer}
  end
end
