defmodule DropAlleyWeb.PartnerControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.ChannelPartner

  @create_attrs %{active: true, address: "some address", contact_no: "some contact_no", current_location: %{}, name: "some name", verified: true}
  @update_attrs %{active: false, address: "some updated address", contact_no: "some updated contact_no", current_location: %{}, name: "some updated name", verified: false}
  @invalid_attrs %{active: nil, address: nil, contact_no: nil, current_location: nil, name: nil, verified: nil}

  def fixture(:partner) do
    {:ok, partner} = ChannelPartner.create_partner(@create_attrs)
    partner
  end

  describe "index" do
    test "lists all partners", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :index)
      assert html_response(conn, 200) =~ "Partners"
    end
  end

  describe "new partner" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :new)
      assert html_response(conn, 200) =~ "New Partner"
    end
  end

  describe "create partner" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :create), partner: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.partner_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Partner Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :create), partner: @invalid_attrs
      assert html_response(conn, 200) =~ "New Partner"
    end
  end

  describe "edit partner" do
    setup [:create_partner]

    test "renders form for editing chosen partner", %{conn: conn, partner: partner} do
      conn = get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :edit, partner)
      assert html_response(conn, 200) =~ "Edit Partner"
    end
  end

  describe "update partner" do
    setup [:create_partner]

    test "redirects when data is valid", %{conn: conn, partner: partner} do
      conn = put conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :update, partner), partner: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.partner_path(conn, :show, partner)

      conn = get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :show, partner)
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, partner: partner} do
      conn = put conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :update, partner), partner: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Partner"
    end
  end

  describe "delete partner" do
    setup [:create_partner]

    test "deletes chosen partner", %{conn: conn, partner: partner} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :delete, partner)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.partner_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.partner_path(conn, :show, partner)
      end
    end
  end

  defp create_partner(_) do
    partner = fixture(:partner)
    {:ok, partner: partner}
  end
end
