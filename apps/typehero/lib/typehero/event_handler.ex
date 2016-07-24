defmodule Typehero.EventHandler do
  use GenServer
  alias Typehero.EventHandler.KeyFingerMatch
  alias Typehero.Text

  def start_link() do
    GenServer.start_link(__MODULE__, {%{}, %{}})
  end

  def key_event(pid, key, count) do
    IO.inspect __MODULE__
    GenServer.cast(pid, {:receive, :key_event, key, count})
  end

  def get_state(pid) do
    GenServer.call(pid, :status)
  end

  def finger_event(pid, finger, count) do
    GenServer.cast(pid, {:receive, :finger_event, finger, count})
  end

  def init do
    state = {%{}, %{}}
    {:ok, state}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:receive, :key_event, key, count}, {keyboard_events, finger_events}) do
    IO.puts "did we get here?"
    process_keyboard_event(Map.get(finger_events, count), keyboard_events, finger_events, count, key)
  end

  def handle_cast({:receive, :finger_event, key, count}, {keyboard_events, finger_events}) do
    process_finger_event(Map.get(finger_events, count), keyboard_events, finger_events, count, key)
  end

  def process_keyboard_event(nil, keyboard_events, finger_events, count, key) do
    {:noreply, {Map.put(keyboard_events, count, key), finger_events}}
  end

  def process_finger_event(nil, keyboard_events, finger_events, count, finger) do
    IO.puts "alilya"
    {:noreply, {keyboard_events, Map.put(finger_events, count, finger)}}
  end

  def process_keyboard_event(finger, keyboard_events, finger_events, count, key) do
    correct_key_finger(KeyFingerMatch.match_key_to_finger(finger, String.to_atom(key)))
    #TODO call Text.get_current_letter from here and get the letter
    #Proceed with refactoring matching key-letter logic
    correct_key_letter(Text.get_current_letter == key)
  end

  def correct_key_finger(:match) do
    IO.puts "bla-bla"
  end

  def correct_key_finger(:dismatch) do
    IO.puts "well. not matching also a result"
  end

  def correct_key_letter(true) do
    IO.puts "inside the correct key_letter"
  end

  def correct_key_letter(false) do
    IO.puts "inside the correct key_letter"
  end

  def match_letter_to_key_pressed_from_keyboard(text = [], key, keyboard_events, finger_events, count) do
    {:noreply, :finish}
  end

  def match_letter_to_key_pressed_from_keyboard(text, key, keyboard_events, finger_events, count) do
    [first_letter | rest_of_the_text] = text
    cond do
      first_letter == key -> {:noreply, {rest_of_the_text, {keyboard_events, Map.delete(finger_events, count)}}}
      true -> {:reply, :error, {text, {keyboard_events, Map.delete(finger_events, count)}}}
    end
  end

  def match_letter_to_key_pressed_from_finger(text = [], key, keyboard_events, finger_events, count) do
    {:noreply, :finish}
  end

  def match_letter_to_key_pressed_from_finger(text, key, keyboard_events, finger_events, count) do
    [first_letter | rest_of_the_text] = text

    cond do
      first_letter == key -> IO.puts "letter matches"; {:noreply, {rest_of_the_text, {Map.delete(keyboard_events, count), finger_events}}}
      true -> IO.puts "letter dont match"; {:noreply, {text, {Map.delete(keyboard_events, count), finger_events}}}
    end
  end


  def process_finger_event(key, text, keyboard_events, finger_events, count, finger) do
    match_letter_to_key_pressed_from_finger(text, key, keyboard_events, finger_events, count)
  end
end
