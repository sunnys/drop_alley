defmodule DropAlleyWeb.API.V1.BucketView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.BucketView

  def render("index.json", %{buckets: buckets}) do
    %{data: render_many(buckets, BucketView, "bucket.json")}
  end

  def render("show.json", %{bucket: bucket}) do
    %{data: render_one(bucket, BucketView, "bucket.json")}
  end

  def render("bucket.json", %{bucket: bucket}) do
    %{id: bucket.id,
      state: bucket.state,
      active: bucket.active,
      assigned_time: bucket.assigned_time,
      pickup_time: bucket.pickup_time,
      pick_up_location: bucket.pick_up_location,
      drop_time: bucket.drop_time,
      product_id: bucket.product_id,
      partner_id: bucket.partner_id,
      drop_location: bucket.drop_location}
  end
end
