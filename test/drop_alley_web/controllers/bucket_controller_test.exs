defmodule DropAlleyWeb.BucketControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.ChannelPartner

  @create_attrs %{active: true, assigned_time: ~N[2010-04-17 14:00:00.000000], drop_location: %{}, drop_time: ~N[2010-04-17 14:00:00.000000], pick_up_location: %{}, pickup_time: ~N[2010-04-17 14:00:00.000000], state: "some state"}
  @update_attrs %{active: false, assigned_time: ~N[2011-05-18 15:01:01.000000], drop_location: %{}, drop_time: ~N[2011-05-18 15:01:01.000000], pick_up_location: %{}, pickup_time: ~N[2011-05-18 15:01:01.000000], state: "some updated state"}
  @invalid_attrs %{active: nil, assigned_time: nil, drop_location: nil, drop_time: nil, pick_up_location: nil, pickup_time: nil, state: nil}

  def fixture(:bucket) do
    {:ok, bucket} = ChannelPartner.create_bucket(@create_attrs)
    bucket
  end

  describe "index" do
    test "lists all buckets", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :index)
      assert html_response(conn, 200) =~ "Buckets"
    end
  end

  describe "new bucket" do
    test "renders form", %{conn: conn} do
      conn = get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :new)
      assert html_response(conn, 200) =~ "New Bucket"
    end
  end

  describe "create bucket" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :create), bucket: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, id)

      conn = get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Bucket Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :create), bucket: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bucket"
    end
  end

  describe "edit bucket" do
    setup [:create_bucket]

    test "renders form for editing chosen bucket", %{conn: conn, bucket: bucket} do
      conn = get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :edit, bucket)
      assert html_response(conn, 200) =~ "Edit Bucket"
    end
  end

  describe "update bucket" do
    setup [:create_bucket]

    test "redirects when data is valid", %{conn: conn, bucket: bucket} do
      conn = put conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :update, bucket), bucket: @update_attrs
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, bucket)

      conn = get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, bucket)
      assert html_response(conn, 200) =~ "some updated state"
    end

    test "renders errors when data is invalid", %{conn: conn, bucket: bucket} do
      conn = put conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :update, bucket), bucket: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bucket"
    end
  end

  describe "delete bucket" do
    setup [:create_bucket]

    test "deletes chosen bucket", %{conn: conn, bucket: bucket} do
      conn = delete conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :delete, bucket)
      assert redirected_to(conn) == DropAlleyWeb.Router.Helpers.bucket_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, bucket)
      end
    end
  end

  defp create_bucket(_) do
    bucket = fixture(:bucket)
    {:ok, bucket: bucket}
  end
end
