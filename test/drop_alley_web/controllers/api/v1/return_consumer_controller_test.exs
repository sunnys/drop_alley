defmodule DropAlleyWeb.API.V1.ReturnConsumerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store
  alias DropAlley.Store.ReturnConsumer

  @create_attrs %{active: true}
  @update_attrs %{active: false}
  @invalid_attrs %{active: nil}

  def fixture(:return_consumer) do
    {:ok, return_consumer} = Store.create_return_consumer(@create_attrs)
    return_consumer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all return_consumers", %{conn: conn} do
      conn = get conn, api_v1_return_consumer_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create return_consumer" do
    test "renders return_consumer when data is valid", %{conn: conn} do
      conn = post conn, api_v1_return_consumer_path(conn, :create), return_consumer: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_return_consumer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_return_consumer_path(conn, :create), return_consumer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update return_consumer" do
    setup [:create_return_consumer]

    test "renders return_consumer when data is valid", %{conn: conn, return_consumer: %ReturnConsumer{id: id} = return_consumer} do
      conn = put conn, api_v1_return_consumer_path(conn, :update, return_consumer), return_consumer: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_return_consumer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, return_consumer: return_consumer} do
      conn = put conn, api_v1_return_consumer_path(conn, :update, return_consumer), return_consumer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete return_consumer" do
    setup [:create_return_consumer]

    test "deletes chosen return_consumer", %{conn: conn, return_consumer: return_consumer} do
      conn = delete conn, api_v1_return_consumer_path(conn, :delete, return_consumer)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_return_consumer_path(conn, :show, return_consumer)
      end
    end
  end

  defp create_return_consumer(_) do
    return_consumer = fixture(:return_consumer)
    {:ok, return_consumer: return_consumer}
  end
end
