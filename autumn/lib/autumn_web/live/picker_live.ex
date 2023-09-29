defmodule AutumnWeb.PickerLive do
  # Create Picker to show reading list, includes previous, next, pick buttons
  # Pick button specifications
  # When a reading button is clicked, use push_navigate to send user to ~p"
  use AutumnWeb, :live_view

  alias Autumn.Library

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.phrase text={Enum.fetch!(@readings_list, @selected_index).phrase} />
      </div>
      <div>
        <.button phx-click="previous">Previous</.button>
        <.button phx-click="picker">Picker</.button>
        <.button phx-click="next">Next</.button>
      </div>
    </div>
    """
  end

  attr :text, :string, required: true
  def phrase(assigns) do
    ~H"""
    <span>
      <%= @text %>
    </span>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      subscribe()
    end

    readings_list = Library.list_readings()

    socket =
      socket
      |> assign(:readings_list, readings_list)
      |> assign(:selected_index, 0)

    {:ok, socket}
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Autumn.PubSub, Autumn.Library.topic())
  end

  @impl true
  def handle_event("previous", _params, %{assigns: %{selected_index: selected_index, readings_list: readings_list}} = socket) do
    new_selected_index = if selected_index == 0 do
      length(readings_list) - 1
    else
      selected_index - 1
    end

    {:noreply, assign(socket, :selected_index, new_selected_index)}
  end

  def handle_event("next", _params, %{assigns: %{selected_index: selected_index, readings_list: readings_list}} = socket) do
    new_selected_index = if selected_index == (length(readings_list) - 1) do
      0
    else
      selected_index + 1
    end

    {:noreply, assign(socket, :selected_index, new_selected_index)}
  end

  def handle_event("picker", _unsigned_params, socket) do
    reading = Enum.fetch!(socket.assigns.readings_list, socket.assigns.selected_index)
    {
      :noreply,
      push_navigate(socket, to: ~p"/eraser/#{reading}")
    }
  end

  @impl true
  def handle_info("library changed", socket) do

    readings_list = Library.list_readings()

    socket =
      socket
      |> assign(:readings_list, readings_list)
      |> assign(:selected_index, 0)

    {:noreply, socket}
  end
end
