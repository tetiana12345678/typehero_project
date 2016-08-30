defmodule Typehero.MatcherTest do
  use ExUnit.Case
  alias Typehero.Matcher

  test "pressing h key with finger 1" do
    assert Matcher.match("h", 1, "h") == :all_match
  end

  test "pressing h key with finger 2" do
    assert Matcher.match("h", 2, "h") == :right_key_wrong_finger
  end

  test "pressing j key with finger 1" do
    assert Matcher.match("j", 1, "h") == :wrong_key_right_finger
  end

  test "pressing j key with finger 2" do
    assert Matcher.match("j", 2, "h") == :no_match
  end

  test "pressing space bar with right thumb" do
    assert Matcher.match(" ", 5, " ") == :all_match
  end

  test "pressing space bar with left thumb" do
    assert Matcher.match(" ", 10, " ") == :all_match
  end
end
