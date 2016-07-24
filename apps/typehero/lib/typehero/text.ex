defmodule Typehero.Text do
  use GenServer


  def start_link() do
    GenServer.start_link(__MODULE__, "a")
  end

  def key_press(pid, key, count) do
    GenServer.cast(pid, {:receive, :keyboard, key, count})
  end

  def get_state(pid) do
    GenServer.call(pid, :status)
  end

  def get_current_letter(pid) do
    GenServer.call(pid, :current_letter)
  end

  def finger_press(pid, finger, count) do
    GenServer.cast(pid, {:receive, :finger, finger, count})  #change to __MODULE__ instead of pid
  end

  def init(text) do
    {:ok, {String.codepoints(text)}}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:current_letter, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, :keyboard, key, count}, current_letter) do
    #TODO call Typehero.EventHandler.key_event from here and make sure handle_cast({:receive, :key_event, ...}) is triggered
    {:ok, pid} = Typehero.EventHandler.start_link
    Typehero.EventHandler.key_event(pid, key, count)
    {:noreply, current_letter}
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
