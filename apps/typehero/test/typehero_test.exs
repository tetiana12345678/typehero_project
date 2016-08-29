defmodule TypeheroTest do
  use ExUnit.Case
  doctest Typehero

  alias Typehero.Core
  alias Typehero.EventHandler, as: EH
  alias Typehero.Events

  test "get_text returns text" do
    assert Core.get_text == "hello"
  end

  test "get_current letter returns first letter in the text" do
    assert Core.get_current_letter == "h"
  end

  test "key_press flow is correct" do
    Core.key_press("q", 1, nil)
    :timer.sleep(10)
    assert EH.get_state == %Events{finger_events: %{}, key_events: %{1 => "q"}}

    Core.finger_press(1, 1)
    :timer.sleep(10)
    assert EH.get_state == %Events{finger_events: %{}, key_events: %{}}
  end

  test "finger_press flow is correct" do
    Core.finger_press(1, 1)
    :timer.sleep(10)
    assert EH.get_state == %Events{finger_events: %{1 => 1}, key_events: %{}}
    Core.key_press("q", 1, nil)
    :timer.sleep(10)
    assert EH.get_state == %Events{finger_events: %{}, key_events: %{}}
  end
end
