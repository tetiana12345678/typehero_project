defmodule Typehero.Text do
  use GenServer

  def start_link do
    IO.puts "got here boo"
    IO.puts "started Text worker"
    IO.inspect __MODULE__
    GenServer.start_link(__MODULE__, [], name: :text)
  end

  def get_text do
    GenServer.call(:text, :get_text)
  end

  def key_press(key, count) do
    GenServer.cast(:text, {:receive, :key_press, key, count})
  end

  def finger_press(finger, count) do
    GenServer.cast(:text, {:receive, :finger, finger, count})
  end

  def get_current_letter do
    GenServer.call(:text, :get_current_letter)
  end

  def init(state) do
    # Get text from Ecto...
    state = "Hello keith you crazy kid"
    {:ok, state}
  end

  def handle_call(:get_text, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_current_letter, _from, state) do
    current_letter = String.at(state, 0)
    {:reply, current_letter, state}
  end

  def handle_cast({:receive, :finger, finger, count}, current_letter) do
    IO.puts "hello you"
    # EventHandler.process_finger_event(
    #   Map.get(keyboard_events, count),
    #   text,
    #   keyboard_events,
    #   finger_events,
    #   count,
    #   finger
    # )
    {:noreply, current_letter}
  end

  def handle_cast({:receive, :key_press, key, count}, current_letter) do
    #TODO call Typehero.EventHandler.key_event from here and make sure handle_cast({:receive, :key_event, ...}) is triggered
    # {:ok, pid} = Typehero.EventHandler.start_link
    # Typehero.EventHandler.key_event(pid, key, count)
    {:noreply, current_letter}
  end
end
