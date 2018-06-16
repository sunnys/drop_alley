defmodule DropAlleyWeb.API.V1.CartControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Cart

  @create_attrs %{active: true, state: "some state"}
  @update_attrs %{active: false, state: "some updated state"}
  @invalid_attrs %{active: nil, state: nil}

  def fixture(:cart) do
    {:ok, cart} = Purchase.create_cart(@create_attrs)
    cart
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all carts", %{conn: conn} do
      conn = get conn, api_v1_cart_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cart" do
    test "renders cart when data is valid", %{conn: conn} do
      conn = post conn, api_v1_cart_path(conn, :create), cart: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_cart_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true,
        "state" => "some state"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_cart_path(conn, :create), cart: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cart" do
    setup [:create_cart]

    test "renders cart when data is valid", %{conn: conn, cart: %Cart{id: id} = cart} do
      conn = put conn, api_v1_cart_path(conn, :update, cart), cart: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_cart_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false,
        "state" => "some updated state"}
    end

    test "renders errors when data is invalid", %{conn: conn, cart: cart} do
      conn = put conn, api_v1_cart_path(conn, :update, cart), cart: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cart" do
    setup [:create_cart]

    test "deletes chosen cart", %{conn: conn, cart: cart} do
      conn = delete conn, api_v1_cart_path(conn, :delete, cart)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_cart_path(conn, :show, cart)
      end
    end
  end

  defp create_cart(_) do
    cart = fixture(:cart)
    {:ok, cart: cart}
  end
end
