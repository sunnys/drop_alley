defmodule DropAlleyWeb.ProductReviewControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store

  @create_attrs %{image: "some image", name: "some name", rating: 42}
  @update_attrs %{image: "some updated image", name: "some updated name", rating: 43}
  @invalid_attrs %{image: nil, name: nil, rating: nil}

  def fixture(:product_review) do
    {:ok, product_review} = Store.create_product_review(@create_attrs)
    product_review
  end

  describe "index" do
    test "lists all product_reviews", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :index)
      assert html_response(conn, 200) =~ "Product reviews"
    end
  end

  describe "new product_review" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :new)
      assert html_response(conn, 200) =~ "New Product review"
    end
  end

  describe "create product_review" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :create), product_review: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Product review Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :create), product_review: @invalid_attrs
      assert html_response(conn, 200) =~ "New Product review"
    end
  end

  describe "edit product_review" do
    setup [:create_product_review]

    test "renders form for editing chosen product_review", %{conn: conn, product_review: product_review} do
      conn = get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :edit, product_review)
      assert html_response(conn, 200) =~ "Edit Product review"
    end
  end

  describe "update product_review" do
    setup [:create_product_review]

    test "redirects when data is valid", %{conn: conn, product_review: product_review} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :update, product_review), product_review: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, product_review)

      conn = get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, product_review)
      assert html_response(conn, 200) =~ "some updated image"
    end

    test "renders errors when data is invalid", %{conn: conn, product_review: product_review} do
      conn = put conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :update, product_review), product_review: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Product review"
    end
  end

  describe "delete product_review" do
    setup [:create_product_review]

    test "deletes chosen product_review", %{conn: conn, product_review: product_review} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :delete, product_review)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.product_review_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.product_review_path(conn, :show, product_review)
      end
    end
  end

  defp create_product_review(_) do
    product_review = fixture(:product_review)
    {:ok, product_review: product_review}
  end
end
