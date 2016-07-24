defmodule Typehero.EventHandler.KeyFingerMatchTest do
  use ExUnit.Case
  alias Typehero.EventHandler.KeyFingerMatch
  doctest Typehero.EventHandler.KeyFingerMatch

  test "it returns :match if key pressed with right finger" do
    assert KeyFingerMatch.match_key_to_finger(9, :q) == :match
  end

  test "it returns :dismatch if key pressed with wrong finger" do
    assert KeyFingerMatch.match_key_to_finger(8, :q) == :dismatch
  end
end
