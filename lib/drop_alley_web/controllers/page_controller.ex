defmodule DropAlleyWeb.PageController do
  use DropAlleyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
