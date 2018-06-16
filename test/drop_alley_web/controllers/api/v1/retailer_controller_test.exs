defmodule DropAlleyWeb.API.V1.RetailerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Store
  alias DropAlley.Store.Retailer

  @create_attrs %{active: true, api_key: "some api_key", details: %{}, name: "some name"}
  @update_attrs %{active: false, api_key: "some updated api_key", details: %{}, name: "some updated name"}
  @invalid_attrs %{active: nil, api_key: nil, details: nil, name: nil}

  def fixture(:retailer) do
    {:ok, retailer} = Store.create_retailer(@create_attrs)
    retailer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all retailers", %{conn: conn} do
      conn = get conn, api_v1_retailer_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create retailer" do
    test "renders retailer when data is valid", %{conn: conn} do
      conn = post conn, api_v1_retailer_path(conn, :create), retailer: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_retailer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true,
        "api_key" => "some api_key",
        "details" => %{},
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_retailer_path(conn, :create), retailer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update retailer" do
    setup [:create_retailer]

    test "renders retailer when data is valid", %{conn: conn, retailer: %Retailer{id: id} = retailer} do
      conn = put conn, api_v1_retailer_path(conn, :update, retailer), retailer: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_retailer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false,
        "api_key" => "some updated api_key",
        "details" => %{},
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, retailer: retailer} do
      conn = put conn, api_v1_retailer_path(conn, :update, retailer), retailer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete retailer" do
    setup [:create_retailer]

    test "deletes chosen retailer", %{conn: conn, retailer: retailer} do
      conn = delete conn, api_v1_retailer_path(conn, :delete, retailer)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_retailer_path(conn, :show, retailer)
      end
    end
  end

  defp create_retailer(_) do
    retailer = fixture(:retailer)
    {:ok, retailer: retailer}
  end
end
