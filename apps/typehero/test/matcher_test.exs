defmodule Typehero.MatcherTest do
  use ExUnit.Case
  alias Typehero.Matcher

  # Letter = "h", Key "h", Finger 1 = :all_match
  # Letter = "h", Key "h", Finger 2 = :right_key_wrong_finger
  # Letter = "h", Key "j", Finger 1 = :wrong_key_right_finger
  # Letter = "h", Key "j", Finger 3 = :no_match

  test "it returns :all_match" do
    assert Matcher.match("h", 1, "h") == :all_match
  end

  test "it returns :wrong_finger" do
    assert Matcher.match("h", 2, "h") == :right_key_wrong_finger
  end

  test "it returns :wrong_key" do
    assert Matcher.match("j", 1, "h") == :wrong_key_right_finger
  end

  test "it returns :no_match" do
    assert Matcher.match("j", 2, "h") == :no_match
  end
end
