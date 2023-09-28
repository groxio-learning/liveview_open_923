defmodule AutumnWeb.PickerLive do
  # Create Picker to show reading list, includes previous, next, pick buttons
  # Pick button specifications
  # When a reading button is clicked, use push_navigate to send user to ~p"
  use AutumnWeb, :live_view

  alias Autumn.Library

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- <div :for={{phrase, id} <- @readings_list} id={"reading-#{id}"} >
      <p>
        <%= phrase %>
      </p>
    </div> --%>

    <div>
      <div>
        <.button phx-click="previous">Previous</.button>
          <span><%= Enum.fetch!(@readings_list, @selected_index).phrase %></span>
        <.button phx-click="previous">Previous</.button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    readings_list = Library.list_readings()

    socket =
      socket
      |> assign(:readings_list, readings_list)
      |> assign(:selected_index, 0)


    {:ok, socket}
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