defmodule Typehero.KeyFingerMatchTest do
  use ExUnit.Case
  alias Typehero.KeyFingerMatch
  doctest Typehero.KeyFingerMatch

  test "it returns :match if key pressed with right finger" do
    assert KeyFingerMatch.match("q", 9) == :match
  end

  test "it returns :dismatch if key pressed with wrong finger" do
    assert KeyFingerMatch.match("q", 8) == :dismatch
  end
end
