defmodule DropAlleyWeb.API.V1.ProductImageControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store
  alias DropAlley.Store.ProductImage

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:product_image) do
    {:ok, product_image} = Store.create_product_image(@create_attrs)
    product_image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_images", %{conn: conn} do
      conn = get conn, api_v1_product_image_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_image" do
    test "renders product_image when data is valid", %{conn: conn} do
      conn = post conn, api_v1_product_image_path(conn, :create), product_image: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_product_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_product_image_path(conn, :create), product_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_image" do
    setup [:create_product_image]

    test "renders product_image when data is valid", %{conn: conn, product_image: %ProductImage{id: id} = product_image} do
      conn = put conn, api_v1_product_image_path(conn, :update, product_image), product_image: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_product_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, product_image: product_image} do
      conn = put conn, api_v1_product_image_path(conn, :update, product_image), product_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_image" do
    setup [:create_product_image]

    test "deletes chosen product_image", %{conn: conn, product_image: product_image} do
      conn = delete conn, api_v1_product_image_path(conn, :delete, product_image)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_product_image_path(conn, :show, product_image)
      end
    end
  end

  defp create_product_image(_) do
    product_image = fixture(:product_image)
    {:ok, product_image: product_image}
  end
end
