defmodule DropAlleyWeb.ProductControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store

  @create_attrs %{description: "some description", inspection_process: %{}, name: "some name", prprice: 120.5, state: "some state"}
  @update_attrs %{description: "some updated description", inspection_process: %{}, name: "some updated name", prprice: 456.7, state: "some updated state"}
  @invalid_attrs %{description: nil, inspection_process: nil, name: nil, prprice: nil, state: nil}

  def fixture(:product) do
    {:ok, product} = Store.create_product(@create_attrs)
    product
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :index)
      assert html_response(conn, 200) =~ "Products"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :new)
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_path(conn, :create), product: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Product Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_path(conn, :create), product: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :edit, product)
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn, product: product} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_path(conn, :update, product), product: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_path(conn, :show, product)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :show, product)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_path(conn, :update, product), product: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.product_path(conn, :delete, product)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.product_path(conn, :show, product)
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
