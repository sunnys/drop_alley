defmodule DropAlleyWeb.API.V1.ProductReviewControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store
  alias DropAlley.Store.ProductReview

  @create_attrs %{image: "some image", name: "some name", rating: 42}
  @update_attrs %{image: "some updated image", name: "some updated name", rating: 43}
  @invalid_attrs %{image: nil, name: nil, rating: nil}

  def fixture(:product_review) do
    {:ok, product_review} = Store.create_product_review(@create_attrs)
    product_review
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_reviews", %{conn: conn} do
      conn = get conn, api_v1_product_review_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_review" do
    test "renders product_review when data is valid", %{conn: conn} do
      conn = post conn, api_v1_product_review_path(conn, :create), product_review: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_product_review_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "image" => "some image",
        "name" => "some name",
        "rating" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_product_review_path(conn, :create), product_review: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_review" do
    setup [:create_product_review]

    test "renders product_review when data is valid", %{conn: conn, product_review: %ProductReview{id: id} = product_review} do
      conn = put conn, api_v1_product_review_path(conn, :update, product_review), product_review: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_product_review_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "image" => "some updated image",
        "name" => "some updated name",
        "rating" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, product_review: product_review} do
      conn = put conn, api_v1_product_review_path(conn, :update, product_review), product_review: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_review" do
    setup [:create_product_review]

    test "deletes chosen product_review", %{conn: conn, product_review: product_review} do
      conn = delete conn, api_v1_product_review_path(conn, :delete, product_review)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_product_review_path(conn, :show, product_review)
      end
    end
  end

  defp create_product_review(_) do
    product_review = fixture(:product_review)
    {:ok, product_review: product_review}
  end
end
