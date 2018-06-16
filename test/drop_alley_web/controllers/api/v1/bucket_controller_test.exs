defmodule DropAlleyWeb.API.V1.BucketControllerTest do
  use DropAlleyWeb.ConnCase

  alias DropAlley.ChannelPartner
  alias DropAlley.ChannelPartner.Bucket

  @create_attrs %{active: true, assigned_time: ~N[2010-04-17 14:00:00.000000], drop_location: %{}, drop_time: ~N[2010-04-17 14:00:00.000000], pick_up_location: %{}, pickup_time: ~N[2010-04-17 14:00:00.000000], state: "some state"}
  @update_attrs %{active: false, assigned_time: ~N[2011-05-18 15:01:01.000000], drop_location: %{}, drop_time: ~N[2011-05-18 15:01:01.000000], pick_up_location: %{}, pickup_time: ~N[2011-05-18 15:01:01.000000], state: "some updated state"}
  @invalid_attrs %{active: nil, assigned_time: nil, drop_location: nil, drop_time: nil, pick_up_location: nil, pickup_time: nil, state: nil}

  def fixture(:bucket) do
    {:ok, bucket} = ChannelPartner.create_bucket(@create_attrs)
    bucket
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all buckets", %{conn: conn} do
      conn = get conn, api_v1_bucket_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bucket" do
    test "renders bucket when data is valid", %{conn: conn} do
      conn = post conn, api_v1_bucket_path(conn, :create), bucket: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_v1_bucket_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => true,
        "assigned_time" => ~N[2010-04-17 14:00:00.000000],
        "drop_location" => %{},
        "drop_time" => ~N[2010-04-17 14:00:00.000000],
        "pick_up_location" => %{},
        "pickup_time" => ~N[2010-04-17 14:00:00.000000],
        "state" => "some state"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_v1_bucket_path(conn, :create), bucket: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bucket" do
    setup [:create_bucket]

    test "renders bucket when data is valid", %{conn: conn, bucket: %Bucket{id: id} = bucket} do
      conn = put conn, api_v1_bucket_path(conn, :update, bucket), bucket: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_v1_bucket_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => false,
        "assigned_time" => ~N[2011-05-18 15:01:01.000000],
        "drop_location" => %{},
        "drop_time" => ~N[2011-05-18 15:01:01.000000],
        "pick_up_location" => %{},
        "pickup_time" => ~N[2011-05-18 15:01:01.000000],
        "state" => "some updated state"}
    end

    test "renders errors when data is invalid", %{conn: conn, bucket: bucket} do
      conn = put conn, api_v1_bucket_path(conn, :update, bucket), bucket: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bucket" do
    setup [:create_bucket]

    test "deletes chosen bucket", %{conn: conn, bucket: bucket} do
      conn = delete conn, api_v1_bucket_path(conn, :delete, bucket)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_v1_bucket_path(conn, :show, bucket)
      end
    end
  end

  defp create_bucket(_) do
    bucket = fixture(:bucket)
    {:ok, bucket: bucket}
  end
end
