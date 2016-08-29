defmodule Typehero.EventHandler do
  use GenServer
  alias Typehero.EventHandler.KeyFingerMatch
  alias Typehero.Core
  alias Typehero.Events

  def start_link() do
    GenServer.start_link(__MODULE__, %Events{}, name: :event_handler)
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
    state = %Events{}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, :key_event, key, count}, events = %Events{finger_events: finger_events}) do
    process_key_event(Map.get(finger_events, count), events, count, key)
  end

  def handle_cast({:receive, :finger_event, finger, count}, events = %Events{key_events: key_events}) do
    process_finger_event(Map.get(key_events, count), events, count, finger)
  end

  defp process_key_event(nil, events = %Events{key_events: key_events}, count, key) do
    updated_key_events_map = Map.put(key_events, count, key)
    {:noreply, Map.put(%Events{}, :key_events, updated_key_events_map)}
  end

  defp process_key_event(finger, struct = %Events{}, count, key) do
    match_result = KeyFingerMatch.match_key_to_finger(finger, String.to_atom(key))
    correct_key_finger(match_result, key, count, struct)
  end

  defp process_finger_event(nil, events = %Events{finger_events: finger_events}, count, finger) do
    updated_finger_events_map = Map.put(finger_events, count, finger)
    {:noreply, Map.put(%Events{}, :finger_events, updated_finger_events_map)}
  end

  defp process_finger_event(key, events = %Events{}, count, finger) do
    match_result = KeyFingerMatch.match_key_to_finger(finger, String.to_atom(key))
    correct_key_finger(match_result, key, count, events)
  end

  defp correct_key_finger(:match = result, key, count, events) do
    correct_key_letter(Core.get_current_letter == key, result, count, events)
  end

  defp correct_key_finger(:dismatch = result, key, count, events) do
    correct_key_letter(Core.get_current_letter == key, result, count, events)
  end

  defp correct_key_letter(true, :match, count, events) do
    Core.update_text
    Core.notify_web(%{result: :all_match, count: count})
    {:noreply, delete_event(events, count)}
  end

  defp correct_key_letter(true, :dismatch, count, events) do
    Core.notify_web(%{result: :letter_key, count: count})
    {:noreply, delete_event(events, count)}
  end

  defp correct_key_letter(false, :match, count, events) do
    Core.notify_web(%{result: :finger_key, count: count})
    {:noreply, delete_event(events, count)}
  end

  defp correct_key_letter(false, :dismatch, count, events) do
    Core.notify_web(%{result: :nothing_match, count: count})
    {:noreply, delete_event(events, count)}
  end

  defp delete_event(events, count) do
    %{events | key_events: Map.delete(events.key_events, count),
      finger_events: Map.delete(events.finger_events, count)
     }
  end
end
