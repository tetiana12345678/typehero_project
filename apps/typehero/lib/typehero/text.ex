defmodule Typehero.Text do
  use GenServer

  def start_link do
    IO.puts "started Text worker"
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

  def notify_web(payload) do
    GenServer.cast(:text, {:receive, payload})
  end

  def init(state) do
    # Get text from Ecto...
    state = %{text: "Hello keith you crazy kid", socket: %{}}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_text, _from, state = %{text: text}) do
    {:reply, text, state}
  end

  def handle_call(:get_current_letter, _from, state = %{text: text}) do
    current_letter = String.at(text, 0)
    {:reply, current_letter, state}
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
