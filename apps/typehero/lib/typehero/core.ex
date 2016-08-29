defmodule Typehero.Core do
  use GenServer

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

  def key_press(key, count, socket) do
    GenServer.cast(__MODULE__, {:receive, :key_press, key, count, socket})
  end

  def finger_press(finger, count) do
    GenServer.cast(__MODULE__, {:receive, :finger, finger, count})
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

  def handle_cast({:receive, :finger, finger, count}, state) do
    Typehero.EventHandler.finger_event(finger, count)
    {:noreply, state}
  end

  def handle_cast({:receive, :key_press, key, count, socket}, state) do
    Typehero.EventHandler.key_event(key, count)
    {:noreply, %{state | socket: socket}}
  end

  def handle_cast({:event_handler_result, payload = %{result: :all_match}}, state = %{text: text}) do
    TypeheroWeb.LobbyChannel.handle_in("result", payload, state.socket)
    {:noreply, %{state | text: remove_first_letter(text)}}
  end

  def handle_cast({:event_handler_result, payload}, state) do
    TypeheroWeb.LobbyChannel.handle_in("result", payload, state.socket)
    {:noreply, state}
  end

  defp remove_first_letter(text) do
    [_, del: updated_text] = String.myers_difference(text, String.first(text))
    updated_text
  end
end
