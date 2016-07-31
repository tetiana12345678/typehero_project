defmodule Typehero.KeyFinger do
  defstruct key_events: %{}, finger_events: %{}
end

defmodule Typehero.EventHandler do
  use GenServer
  alias Typehero.EventHandler.KeyFingerMatch
  alias Typehero.Text
  alias Typehero.KeyFinger

  def start_link() do
    GenServer.start_link(__MODULE__, %KeyFinger{}, name: :event_handler)
  end

  def key_event(key, count) do
    GenServer.cast(:event_handler, {:receive, :key_event, key, count})
  end

  def finger_event(finger, count) do
    GenServer.cast(:event_handler, {:receive, :finger_event, finger, count})
  end

  def get_state do
    GenServer.call(:event_handler, :get_state)
  end

  def init do
    state = %KeyFinger{}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, :key_event, key, count}, events = %KeyFinger{finger_events: finger_events}) do
    process_key_event(Map.get(finger_events, count), events, count, key)
  end

  def handle_cast({:receive, :finger_event, finger, count}, events = %KeyFinger{key_events: key_events}) do
    process_finger_event(Map.get(key_events, count), events, count, finger)
  end

  defp process_key_event(nil, events = %KeyFinger{key_events: key_events}, count, key) do
    updated_key_events_map = Map.put(key_events, count, key)
    {:noreply, Map.put(%KeyFinger{}, :key_events, updated_key_events_map)}
  end

  defp process_key_event(finger, %KeyFinger{}, count, key) do
    match_result = KeyFingerMatch.match_key_to_finger(finger, String.to_atom(key))
    correct_key_finger(match_result, key, count)
  end

  defp process_finger_event(nil, events = %KeyFinger{finger_events: finger_events}, count, finger) do
    updated_finger_events_map = Map.put(finger_events, count, finger)
    {:noreply, Map.put(%KeyFinger{}, :finger_events, updated_finger_events_map)}
  end

  defp process_finger_event(key, %KeyFinger{}, count, finger) do
    match_result = KeyFingerMatch.match_key_to_finger(finger, String.to_atom(key))
    correct_key_finger(match_result, key, count)
  end

  defp correct_key_finger(:match, key, count) do
    correct_key_letter(Text.get_current_letter == key, count)
  end

  defp correct_key_finger(:dismatch, key, count) do
    correct_key_letter(Text.get_current_letter == key, count)
  end

  defp correct_key_letter(true, count) do
    struct = %KeyFinger{}
    IO.puts "notify the UI web and serial"
    IO.puts "update current text index"
    {:noreply, %{struct | key_events: Map.delete(struct.key_events, count), finger_events: Map.delete(struct.finger_events, count)}}
  end

  defp correct_key_letter(false, count) do
    struct = %KeyFinger{}
    IO.puts "notify the UI web and serial"
    IO.puts "update current text index"
    {:noreply, %{struct | key_events: Map.delete(struct.key_events, count), finger_events: Map.delete(struct.finger_events, count)}}
  end
end
