defmodule TypeheroTest do
  use ExUnit.Case
  doctest Typehero

  test "keyboard events - typing letter with correct finger and key" do
    {:ok, pid} = Typehero.start_game("ok")
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["o", "k"], {%{1 => "o"}, %{}}}

    Typehero.key_press(pid, "k", 2)
    Typehero.finger_press(pid, 3, 1)  # 3 is the number of finger - right fourth

    assert Typehero.get_state(pid) == {["k"], {%{2 => "k"}, %{}}}
  end

  test "keyboard events - return 'finish' when typed all given text" do
    {:ok, pid} = Typehero.start_game("o")
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["o"], {%{1 => "o"}, %{}}}

    Typehero.finger_press(pid, 3, 1)
    Typehero.key_press(pid, "k", 2)
    Typehero.finger_press(pid, 2, 2)

    assert Typehero.get_state(pid) == :finish
  end

  test "arduino events - typing letter with correct finger and key" do
    {:ok, pid} = Typehero.start_game("ok")
    Typehero.finger_press(pid, 3, 1)

    assert Typehero.get_state(pid) == {["o", "k"], {%{}, %{1 => 3}}}

    Typehero.finger_press(pid, 2, 2)
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["k"], {%{}, %{2 => 2}}}
  end

  test "arduino events - return 'finish' when typed all given text" do
    {:ok, pid} = Typehero.start_game("o")
    Typehero.finger_press(pid, 3, 1)

    assert Typehero.get_state(pid) == {["o"], {%{}, %{1 => 3}}}

    Typehero.key_press(pid, "o", 1)
    Typehero.finger_press(pid, 2, 2)
    Typehero.key_press(pid, "k", 2)

    assert Typehero.get_state(pid) == :finish
  end
end
