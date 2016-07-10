defmodule TypeheroTest do
  use ExUnit.Case
  doctest Typehero

  test "keyboard events - typing letter with correct finger and key" do
    {:ok, pid} = Typehero.start_game("ok")
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["o", "k"], {%{1 => "o"}, %{}}}

    Typehero.key_press(pid, "k", 2)
    Typehero.finger_press(pid, "index", 1)

    assert Typehero.get_state(pid) == {["k"], {%{2 => "k"}, %{}}}
  end

  test "keyboard events - return 'finish' when typed all given text" do
    {:ok, pid} = Typehero.start_game("o")
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["o"], {%{1 => "o"}, %{}}}

    Typehero.finger_press(pid, "index", 1)
    Typehero.key_press(pid, "k", 2)
    Typehero.finger_press(pid, "index", 2)

    assert Typehero.get_state(pid) == :finish
  end

  test "arduino events - typing letter with correct finger and key" do
    {:ok, pid} = Typehero.start_game("ok")
    Typehero.finger_press(pid, "index", 1)

    assert Typehero.get_state(pid) == {["o", "k"], {%{}, %{1 => "index"}}}

    Typehero.finger_press(pid, "index", 2)
    Typehero.key_press(pid, "o", 1)

    assert Typehero.get_state(pid) == {["k"], {%{}, %{2 => "index"}}}
  end

  test "arduino events - return 'finish' when typed all given text" do
    {:ok, pid} = Typehero.start_game("o")
    Typehero.finger_press(pid, "index", 1)

    assert Typehero.get_state(pid) == {["o"], {%{}, %{1 => "index"}}}

    Typehero.key_press(pid, "o", 1)
    Typehero.finger_press(pid, "index", 2)
    Typehero.key_press(pid, "k", 2)

    assert Typehero.get_state(pid) == :finish
  end
end
