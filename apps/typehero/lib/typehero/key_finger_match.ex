defmodule Typehero.KeyFingerMatch do
  # Right hand fingers
  @right_index  1  # index
  @right_middle 2  # middle
  @right_fourth 3  # fourth
  @right_pinkie 4  # pinkie
  @right_thumb  5  # thumb
  # Left hand fingers
  @left_index  6  # index
  @left_middle 7  # middle
  @left_fourth 8  # fourth
  @left_pinkie 9  # pinkie
  @left_thumb  10 # thumb

  @key_finger %{q: @left_pinkie,  a: @left_pinkie, z: @left_pinkie,
                w: @left_fourth,  s: @left_fourth, x: @left_fourth,
                e: @left_middle,  d: @left_middle, c: @left_middle,
                r: @left_index,   f: @left_index,  v: @left_index,
                t: @left_index,   g: @left_index,  b: @left_index,
                y: @right_index,  h: @right_index, j: @right_index,
                n: @right_index,  u: @right_index, m: @right_index,
                i: @right_middle, k: @right_middle,
                o: @right_fourth, l: @right_fourth,
                p: @right_pinkie}

  def match(key, finger) do
    get_finger(key) == finger
  end

  defp get_finger(key) do
    Map.get(@key_finger, String.to_atom(key))
  end
end
