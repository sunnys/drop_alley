defmodule DropAlleyWeb.ReturnConsumerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ReturnConsumer

  plug(:put_layout, {DropAlleyWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Store.paginate_return_consumers(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Return consumers. #{inspect(error)}")
        |> redirect(to: DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Store.change_return_consumer(%ReturnConsumer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"return_consumer" => return_consumer_params}) do
    case Store.create_return_consumer(return_consumer_params) do
      {:ok, return_consumer} ->
        conn
        |> put_flash(:info, "Return consumer created successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, return_consumer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    return_consumer = Store.get_return_consumer!(id)
    render(conn, "show.html", return_consumer: return_consumer)
  end

  def edit(conn, %{"id" => id}) do
    return_consumer = Store.get_return_consumer!(id)
    changeset = Store.change_return_consumer(return_consumer)
    render(conn, "edit.html", return_consumer: return_consumer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "return_consumer" => return_consumer_params}) do
    return_consumer = Store.get_return_consumer!(id)

    case Store.update_return_consumer(return_consumer, return_consumer_params) do
      {:ok, return_consumer} ->
        conn
        |> put_flash(:info, "Return consumer updated successfully.")
        |> redirect(to: DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :show, return_consumer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", return_consumer: return_consumer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    return_consumer = Store.get_return_consumer!(id)
    {:ok, _return_consumer} = Store.delete_return_consumer(return_consumer)

    conn
    |> put_flash(:info, "Return consumer deleted successfully.")
    |> redirect(to: DropAlleyWeb.Router.Helpers.return_consumer_path(conn, :index))
  end
end