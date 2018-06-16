defmodule DropAlleyWeb.API.V1.ReturnConsumerController do
  use DropAlleyWeb, :controller

  alias DropAlley.Store
  alias DropAlley.Store.ReturnConsumer

  action_fallback DropAlleyWeb.FallbackController

  def index(conn, _params) do
    return_consumers = Store.list_return_consumers()
    render(conn, "index.json", return_consumers: return_consumers)
  end

  def create(conn, %{"return_consumer" => return_consumer_params}) do
    with {:ok, %ReturnConsumer{} = return_consumer} <- Store.create_return_consumer(return_consumer_params) do
      conn
      |> put_status(:created)
      |> render("show.json", return_consumer: return_consumer)
    end
  end

  def show(conn, %{"id" => id}) do
    return_consumer = Store.get_return_consumer!(id)
    render(conn, "show.json", return_consumer: return_consumer)
  end

  def update(conn, %{"id" => id, "return_consumer" => return_consumer_params}) do
    return_consumer = Store.get_return_consumer!(id)

    with {:ok, %ReturnConsumer{} = return_consumer} <- Store.update_return_consumer(return_consumer, return_consumer_params) do
      render(conn, "show.json", return_consumer: return_consumer)
    end
  end

  def delete(conn, %{"id" => id}) do
    return_consumer = Store.get_return_consumer!(id)
    with {:ok, %ReturnConsumer{}} <- Store.delete_return_consumer(return_consumer) do
      send_resp(conn, :no_content, "")
    end
  end
end
