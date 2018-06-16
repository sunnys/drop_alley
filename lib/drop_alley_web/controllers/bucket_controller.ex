defmodule DropAlleyWeb.BucketController do
  use DropAlleyWeb, :controller

  alias DropAlley.ChannelPartner
  alias DropAlley.ChannelPartner.Bucket

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case ChannelPartner.paginate_buckets(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Buckets. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.bucket_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = ChannelPartner.change_bucket(%Bucket{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bucket" => bucket_params}) do
    case ChannelPartner.create_bucket(bucket_params) do
      {:ok, bucket} ->
        conn
        |> put_flash(:info, "Bucket created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, bucket))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bucket = ChannelPartner.get_bucket!(id)
    render(conn, "show.html", bucket: bucket)
  end

  def edit(conn, %{"id" => id}) do
    bucket = ChannelPartner.get_bucket!(id)
    changeset = ChannelPartner.change_bucket(bucket)
    render(conn, "edit.html", bucket: bucket, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bucket" => bucket_params}) do
    bucket = ChannelPartner.get_bucket!(id)

    case ChannelPartner.update_bucket(bucket, bucket_params) do
      {:ok, bucket} ->
        conn
        |> put_flash(:info, "Bucket updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.bucket_path(conn, :show, bucket))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bucket: bucket, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bucket = ChannelPartner.get_bucket!(id)
    {:ok, _bucket} = ChannelPartner.delete_bucket(bucket)

    conn
    |> put_flash(:info, "Bucket deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.bucket_path(conn, :index))
  end
end