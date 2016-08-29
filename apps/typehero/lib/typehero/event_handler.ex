defmodule Typehero.EventHandler do
  use GenServer
  alias Typehero.KeyFingerMatch
  alias Typehero.Core
  alias Typehero.Events

  # CLIENT

  def start_link() do
    GenServer.start_link(__MODULE__, %Events{}, name: :event_handler)
  end

  def key_event(key, id) do
    GenServer.cast(:event_handler, {:key_event, key, id})
  end

  def finger_event(finger, id) do
    GenServer.cast(:event_handler, {:finger_event, finger, id})
  end

  def get_state do
    GenServer.call(:event_handler, :get_state)
  end

  # SERVER

  def init do
    state = %Events{}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:key_event, key, id}, state) do
    finger = get_event(:finger, state, id)
    new_state = process_key(finger, state, id, key)
    {:noreply, new_state}
  end

  def handle_cast({:finger_event, finger, id}, state) do
    key = get_event(:key, state, id)
    new_state = process_finger(key, state, id, finger)
    {:noreply, new_state}
  end

  # PRIVATE

  defp process_key(nil, events = %Events{key_events: key_events}, id, key) do
    updated_key_events_map = Map.put(key_events, id, key)
    Map.put(%Events{}, :key_events, updated_key_events_map)
  end

  defp process_key(finger, struct = %Events{}, id, key) do
    match_result = KeyFingerMatch.match(finger, key)
    correct_key_finger(match_result, key, id, struct)
  end

  defp process_finger(nil, events = %Events{finger_events: finger_events}, id, finger) do
    updated_finger_events_map = Map.put(finger_events, id, finger)
    Map.put(%Events{}, :finger_events, updated_finger_events_map)
  end

  defp process_finger(key, events = %Events{}, id, finger) do
    match_result = KeyFingerMatch.match(finger, String.to_atom(key))
    correct_key_finger(match_result, key, id, events)
  end

  defp correct_key_finger(:match = result, key, id, events) do
    correct_key_letter(Core.get_current_letter == key, result, id, events)
  end

  defp correct_key_finger(:dismatch = result, key, id, events) do
    correct_key_letter(Core.get_current_letter == key, result, id, events)
  end

  defp correct_key_letter(true, :match, id, events) do
    Core.update_text
    Core.notify_web(%{result: :all_match, id: id})
    delete_event(events, id)
  end

  defp correct_key_letter(true, :dismatch, id, events) do
    Core.notify_web(%{result: :letter_key, id: id})
    delete_event(events, id)
  end

  defp correct_key_letter(false, :match, id, events) do
    Core.notify_web(%{result: :finger_key, id: id})
    delete_event(events, id)
  end

  defp correct_key_letter(false, :dismatch, id, events) do
    Core.notify_web(%{result: :nothing_match, id: id})
    delete_event(events, id)
  end

  defp delete_event(events, id) do
    %{events | key_events: Map.delete(events.key_events, id),
      finger_events: Map.delete(events.finger_events, id)
     }
  end

  defp get_event(:finger, %Events{finger_events: finger_events}, id) do
    Map.get(finger_events, id)
  end

  defp get_event(:key, %Events{key_events: key_events}, id) do
    Map.get(key_events, id)
  end
end
