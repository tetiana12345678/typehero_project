defmodule Typehero.EventHandler do
  use GenServer
  alias Typehero.Matcher
  alias Typehero.Core
  alias Typehero.Events

  # CLIENT

  def start_link() do
    GenServer.start_link(__MODULE__, %Events{}, name: __MODULE__)
  end

  def key_event(key, id) do
    GenServer.cast(__MODULE__, {:key_event, key, id})
  end

  def finger_event(finger, id) do
    GenServer.cast(__MODULE__, {:finger_event, finger, id})
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
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

  defp process_key(nil, state, id, key) do
    add_event(:key, state, id, key)
  end

  defp process_finger(nil, state, id, finger) do
    add_event(:finger, state, id, finger)
  end

  defp process_key(finger, state, id, key) do
    match_all(key, finger, id, state)
  end

  defp process_finger(key, state, id, finger) do
    match_all(key, finger, id, state)
  end

  defp match_all(key, finger, id, state) do
    result = Matcher.match(key, finger, Core.get_current_letter)
    Core.event_handler_result(%{result: result, id: id})
    delete_event(state, id)
  end

  defp delete_event(events, id) do
    %{events | key_events: Map.delete(events.key_events, id),
      finger_events: Map.delete(events.finger_events, id)
     }
  end

  defp get_event(:finger, %Events{finger_events: events}, id) do
    Map.get(events, id)
  end

  defp get_event(:key, %Events{key_events: events}, id) do
    Map.get(events, id)
  end

  defp add_event(:key, %Events{key_events: events}, id, key) do
    events = Map.put(events, id, key)
    Map.put(%Events{}, :key_events, events)
  end

  defp add_event(:finger, %Events{finger_events: events}, id, finger) do
    events = Map.put(events, id, finger)
    Map.put(%Events{}, :finger_events, events)
  end
end
