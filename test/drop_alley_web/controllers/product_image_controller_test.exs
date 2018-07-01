defmodule DropAlleyWeb.ProductImageControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store

  @create_attrs %{image: "some image"}
  @update_attrs %{image: "some updated image"}
  @invalid_attrs %{image: nil}

  def fixture(:product_image) do
    {:ok, product_image} = Store.create_product_image(@create_attrs)
    product_image
  end

  describe "index" do
    test "lists all product_images", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :index)
      assert html_response(conn, 200) =~ "Product images"
    end
  end

  describe "new product_image" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :new)
      assert html_response(conn, 200) =~ "New Product image"
    end
  end

  describe "create product_image" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :create), product_image: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Product image Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :create), product_image: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product image"
    end
  end

  describe "edit product_image" do
    setup [:create_product_image]

    test "renders form for editing chosen product_image", %{conn: conn, product_image: product_image} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :edit, product_image)
      assert html_response(conn, 200) =~ "Edit Product image"
    end
  end

  describe "update product_image" do
    setup [:create_product_image]

    test "redirects when data is valid", %{conn: conn, product_image: product_image} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :update, product_image), product_image: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, product_image)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, product_image)
      assert html_response(conn, 200) =~ "some updated image"
    end

    test "renders errors when data is invalid", %{conn: conn, product_image: product_image} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :update, product_image), product_image: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product image"
    end
  end

  describe "delete product_image" do
    setup [:create_product_image]

    test "deletes chosen product_image", %{conn: conn, product_image: product_image} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :delete, product_image)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_image_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.product_image_path(conn, :show, product_image)
      end
    end
  end

  defp create_product_image(_) do
    product_image = fixture(:product_image)
    {:ok, product_image: product_image}
  end
end
