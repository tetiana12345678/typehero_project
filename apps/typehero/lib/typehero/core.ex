defmodule Typehero.Core do
  use GenServer
  alias TypeheroWeb.LobbyChannel
  alias Typehero.EventHandler

  def start_link do
    IO.puts "started Core worker"
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_text do
    GenServer.call(__MODULE__, :get_text)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def key_press(key, id, socket) do
    GenServer.cast(__MODULE__, {:key, key, id, socket})
  end

  def finger_press(finger, id) do
    GenServer.cast(__MODULE__, {:finger, finger, id})
  end

  def get_current_letter do
    GenServer.call(__MODULE__, :get_current_letter)
  end

  def event_handler_result(result) do
    GenServer.cast(__MODULE__, {:event_handler_result, result})
  end

  def init(state) do
    # Get text from Ecto...
    state = %{text: "hello", socket: %{}}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_text, _from, state = %{text: text}) do
    {:reply, text, state}
  end

  def handle_call(:get_current_letter, _from, state = %{text: text}) do
    {:reply, String.first(text), state}
  end

  def handle_cast({:finger, finger, id}, state) do
    EventHandler.finger_event(finger, id)
    {:noreply, state}
  end

  def handle_cast({:key, key, id, socket}, state) do
    EventHandler.key_event(key, id)
    {:noreply, %{state | socket: socket}}
  end

  def handle_cast({:event_handler_result, payload = %{result: :all_match}}, state = %{text: text}) do
    LobbyChannel.handle_in("result", payload, state.socket)
    {:noreply, %{state | text: remove_first_letter(text)}}
  end

  def handle_cast({:event_handler_result, payload}, state) do
    LobbyChannel.handle_in("result", payload, state.socket)
    {:noreply, state}
  end

  defp remove_first_letter(text) do
    [_, del: updated_text] = String.myers_difference(text, String.first(text))
    updated_text
  end
end
