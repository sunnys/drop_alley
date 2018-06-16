defmodule DropAlleyWeb.API.V1.ProductControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store
  alias DropAlley.Store.Product

  @create_attrs %{description: "some description", inspection_process: %{}, name: "some name", prprice: 120.5, state: "some state"}
  @update_attrs %{description: "some updated description", inspection_process: %{}, name: "some updated name", prprice: 456.7, state: "some updated state"}
  @invalid_attrs %{description: nil, inspection_process: nil, name: nil, prprice: nil, state: nil}

  def fixture(:product) do
    {:ok, product} = Store.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, api_v1_product_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post conn, api_v1_product_path(conn, :create), product: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_product_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "inspection_process" => %{},
        "name" => "some name",
        "prprice" => 120.5,
        "state" => "some state"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_product_path(conn, :create), product: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put conn, api_v1_product_path(conn, :update, product), product: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_product_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "inspection_process" => %{},
        "name" => "some updated name",
        "prprice" => 456.7,
        "state" => "some updated state"}
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put conn, api_v1_product_path(conn, :update, product), product: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete conn, api_v1_product_path(conn, :delete, product)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_product_path(conn, :show, product)
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
