defmodule Typehero.EventHandler.KeyFingerMatch do
  #Right hand fingers
  @right_index "index"
  @right_middle "middle"
  @right_fourth "fourth"
  @right_pinkie "pinkie"
  @right_thumb "thumb"
  #Left hand fingers
  @left_index "index"
  @left_middle "middle"
  @left_fourth "fourth"
  @left_pinkie "pinkie"
  @left_thumb "thumb"

  @key_finger %{"q": @left_pinkie, "a": @left_pinkie, "z": @left_pinkie,
                "w": @left_fourth, "s": @left_fourth, "x": @left_fourth,
                "e": @left_middle, "d": @left_middle, "c": @left_middle,
                "r": @left_index, "f": @left_index, "v": @left_index,
                "t": @left_index, "g": @left_index, "b": @left_index,
                "y": @right_index, "h": @right_index, "j": @right_index,
                "n": @right_index, "u": @right_index, "m": @right_index,
                "i": @right_middle, "k": @right_middle,
                "o": @right_fourth, "l": @right_fourth,
                "p": @right_pinkie}

  def match_key_to_finger(finger, key) do
    IO.puts "inspect #{Map.get(@key_finger, key) == finger}"
  end

end
