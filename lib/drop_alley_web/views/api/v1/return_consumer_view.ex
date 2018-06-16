defmodule DropAlleyWeb.API.V1.ReturnConsumerView do
  use DropAlleyWeb, :view
  alias DropAlleyWeb.API.V1.ReturnConsumerView

  def render("index.json", %{return_consumers: return_consumers}) do
    %{data: render_many(return_consumers, ReturnConsumerView, "return_consumer.json")}
  end

  def render("show.json", %{return_consumer: return_consumer}) do
    %{data: render_one(return_consumer, ReturnConsumerView, "return_consumer.json")}
  end

  def render("return_consumer.json", %{return_consumer: return_consumer}) do
    %{id: return_consumer.id,
      active: return_consumer.active}
  end
end
