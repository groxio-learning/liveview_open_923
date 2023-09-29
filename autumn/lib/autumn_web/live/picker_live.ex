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
      <.phrase :for={product <- @products} text={product} />
      <div>
        <.button phx-click="previous">Previous</.button>
          <.phrase text={Enum.fetch!(@readings_list, @selected_index).phrase} />
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
      |> assign(:products, ~w(Hat Shoe Purse))

    {:ok, socket}
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Autumn.PubSub, Autumn.Library.topic())
  end

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
end
