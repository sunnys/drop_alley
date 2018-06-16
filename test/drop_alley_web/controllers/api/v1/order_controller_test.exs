defmodule DropAlleyWeb.API.V1.OrderControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Purchase
  alias DropAlley.Purchase.Order

  @create_attrs %{active: true, paid: true, payment_type: "some payment_type", purchase: true, state: "some state", trial: true}
  @update_attrs %{active: false, paid: false, payment_type: "some updated payment_type", purchase: false, state: "some updated state", trial: false}
  @invalid_attrs %{active: nil, paid: nil, payment_type: nil, purchase: nil, state: nil, trial: nil}

  def fixture(:order) do
    {:ok, order} = Purchase.create_order(@create_attrs)
    order
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get conn, api_v1_order_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create order" do
    test "renders order when data is valid", %{conn: conn} do
      conn = post conn, api_v1_order_path(conn, :create), order: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_order_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true,
        "paid" => true,
        "payment_type" => "some payment_type",
        "purchase" => true,
        "state" => "some state",
        "trial" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_order_path(conn, :create), order: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update order" do
    setup [:create_order]

    test "renders order when data is valid", %{conn: conn, order: %Order{id: id} = order} do
      conn = put conn, api_v1_order_path(conn, :update, order), order: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_order_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false,
        "paid" => false,
        "payment_type" => "some updated payment_type",
        "purchase" => false,
        "state" => "some updated state",
        "trial" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put conn, api_v1_order_path(conn, :update, order), order: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete conn, api_v1_order_path(conn, :delete, order)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_order_path(conn, :show, order)
      end
    end
  end

  defp create_order(_) do
    order = fixture(:order)
    {:ok, order: order}
  end
end
