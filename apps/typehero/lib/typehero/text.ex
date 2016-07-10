defmodule Typehero.Text do
  use GenServer

  alias Typehero.EventHandler

  def start_link(text) do
    GenServer.start_link(__MODULE__, text)
  end

  def key_press(pid, key, count) do
    GenServer.cast(pid, {:receive, :keyboard, key, count})
  end

  def get_state(pid) do
    GenServer.call(pid, :status)
  end


  def finger_press(pid, finger, count) do
    GenServer.cast(pid, {:receive, :finger, finger, count})  #change to __MODULE__ instead of pid
  end


  def init(text) do
    {:ok, {String.codepoints(text), {%{}, %{}}}}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, :keyboard, key, count}, {text, {keyboard_events, finger_events}}) do
    EventHandler.process_keyboard_event(
      Map.get(finger_events, count),
      text,
      keyboard_events,
      finger_events,
      count,
      key
    )
  end

  def handle_cast({:receive, :finger, finger, count}, {text, {keyboard_events, finger_events}}) do
    EventHandler.process_finger_event(
      Map.get(keyboard_events, count),
      text,
      keyboard_events,
      finger_events,
      count,
      finger
    )
  end
end
