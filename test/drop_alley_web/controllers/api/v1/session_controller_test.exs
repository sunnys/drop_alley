defmodule DropAlleyWeb.API.V1.SessionControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.Account
  alias DropAlley.Account.Session

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:session) do
    {:ok, session} = Account.create_session(@create_attrs)
    session
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, api_v1_session_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create session" do
    test "renders session when data is valid", %{conn: conn} do
      conn = post conn, api_v1_session_path(conn, :create), session: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_session_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_session_path(conn, :create), session: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update session" do
    setup [:create_session]

    test "renders session when data is valid", %{conn: conn, session: %Session{id: id} = session} do
      conn = put conn, api_v1_session_path(conn, :update, session), session: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_session_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put conn, api_v1_session_path(conn, :update, session), session: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete conn, api_v1_session_path(conn, :delete, session)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_session_path(conn, :show, session)
      end
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    {:ok, session: session}
  end
end
