defmodule Typehero.Core do
  use GenServer

  def start_link do
    IO.puts "started Core worker"
    GenServer.start_link(__MODULE__, [], name: :text)
  end

  def get_text do
    GenServer.call(:text, :get_text)
  end

  def get_state do
    GenServer.call(:text, :get_state)
  end

  def key_press(key, count, socket) do
    GenServer.cast(:text, {:receive, :key_press, key, count, socket})
  end

  def finger_press(finger, count) do
    GenServer.cast(:text, {:receive, :finger, finger, count})
  end

  def get_current_letter do
    GenServer.call(:text, :get_current_letter)
  end

  def update_text do
    GenServer.call(:text, :update_text)
  end

  def notify_web(payload) do
    GenServer.cast(:text, {:receive, payload})
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

  def handle_call(:update_text, _from, state = %{text: text}) do
    [_, del: updated_text] = String.myers_difference(text, String.first(text))
    {:reply, %{state | text: updated_text}, state}
  end

  def handle_cast({:receive, :finger, finger, count}, state) do
    Typehero.EventHandler.finger_event(finger, count)
    {:noreply, state}
  end

  def handle_cast({:receive, :key_press, key, count, socket}, state) do
    Typehero.EventHandler.key_event(key, count)
    {:noreply, %{state | socket: socket}}
  end

  def handle_cast({:receive, text}, state) do
    TypeheroWeb.LobbyChannel.handle_in("result", text, state.socket)
    {:noreply, state}
  end
end
