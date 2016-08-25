defmodule TypeheroTest do
  use ExUnit.Case
  doctest Typehero

  alias Typehero.Text
  alias Typehero.EventHandler, as: EH

  test "get_text returns text" do
    assert Text.get_text == "Hello keith you crazy kid"
  end

  test "get_current letter returns first letter in the text" do
    assert Text.get_current_letter == "H"
  end

  test "key_press flow is correct" do
    Text.key_press("q", 1, nil)
    :timer.sleep(10)
    assert EH.get_state == %Typehero.KeyFinger{finger_events: %{}, key_events: %{1 => "q"}}

    Text.finger_press(1, 1)
    :timer.sleep(10)
    assert EH.get_state == %Typehero.KeyFinger{finger_events: %{}, key_events: %{}}
  end

  test "finger_press flow is correct" do
    Text.finger_press(1, 1)
    :timer.sleep(10)
    assert EH.get_state == %Typehero.KeyFinger{finger_events: %{1 => 1}, key_events: %{}}
    Text.key_press("q", 1, nil)
    :timer.sleep(10)
    assert EH.get_state == %Typehero.KeyFinger{finger_events: %{}, key_events: %{}}
  end
end
