defmodule AutumnWeb.EraserLive do
  use AutumnWeb, :live_view

  alias Autumn.TotalRecall

  def mount(%{"id" => id}, _session, socket) do

    reading = Autumn.Library.get_reading!(id)
    {:ok, assign(socket, eraser: Autumn.TotalRecall.new(reading.phrase, reading.steps))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= TotalRecall.show(@eraser) %>
      <.button phx-click="next">Next</.button>
    </div>
    """
  end

  def handle_event("next", _unsigned_params, socket) do
    # Call Eraser reduce function
    eraser = TotalRecall.reduce(socket.assigns.eraser)
    {:noreply, assign(socket, eraser: eraser)}
  end
end
