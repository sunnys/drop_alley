defmodule DropAlleyWeb.API.V1.PartnerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.ChannelPartner
  alias DropAlley.ChannelPartner.Partner

  @create_attrs %{active: true, address: "some address", contact_no: "some contact_no", current_location: %{}, name: "some name", verified: true}
  @update_attrs %{active: false, address: "some updated address", contact_no: "some updated contact_no", current_location: %{}, name: "some updated name", verified: false}
  @invalid_attrs %{active: nil, address: nil, contact_no: nil, current_location: nil, name: nil, verified: nil}

  def fixture(:partner) do
    {:ok, partner} = ChannelPartner.create_partner(@create_attrs)
    partner
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all partners", %{conn: conn} do
      conn = get conn, api_v1_partner_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create partner" do
    test "renders partner when data is valid", %{conn: conn} do
      conn = post conn, api_v1_partner_path(conn, :create), partner: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_partner_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true,
        "address" => "some address",
        "contact_no" => "some contact_no",
        "current_location" => %{},
        "name" => "some name",
        "verified" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_partner_path(conn, :create), partner: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update partner" do
    setup [:create_partner]

    test "renders partner when data is valid", %{conn: conn, partner: %Partner{id: id} = partner} do
      conn = put conn, api_v1_partner_path(conn, :update, partner), partner: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_partner_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false,
        "address" => "some updated address",
        "contact_no" => "some updated contact_no",
        "current_location" => %{},
        "name" => "some updated name",
        "verified" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, partner: partner} do
      conn = put conn, api_v1_partner_path(conn, :update, partner), partner: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete partner" do
    setup [:create_partner]

    test "deletes chosen partner", %{conn: conn, partner: partner} do
      conn = delete conn, api_v1_partner_path(conn, :delete, partner)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_partner_path(conn, :show, partner)
      end
    end
  end

  defp create_partner(_) do
    partner = fixture(:partner)
    {:ok, partner: partner}
  end
end
