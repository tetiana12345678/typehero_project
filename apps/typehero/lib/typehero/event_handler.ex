defmodule Typehero.EventHandler do
  alias Typehero.EventHandler.KeyFingerMatch

  def process_finger_event(nil, text, keyboard_events, finger_events, count, finger) do
    {:noreply, {text, {keyboard_events, Map.put(finger_events, count, finger)}}}
  end

  def process_finger_event(key, text, keyboard_events, finger_events, count, finger) do
    match_letter_to_key_pressed_from_finger(text, key, keyboard_events, finger_events, count)
  end

  def process_keyboard_event(nil, text, keyboard_events, finger_events, count, key) do
    {:noreply, {text, {Map.put(keyboard_events, count, key), finger_events}}}
  end

  def process_keyboard_event(finger, text, keyboard_events, finger_events, count, key) do
    IO.puts "#{finger}"
    IO.puts "#{key}"
    KeyFingerMatch.match_key_to_finger(finger, key)

    match_letter_to_key_pressed_from_keyboard(text, key, keyboard_events, finger_events, count)
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
end
