defmodule Typehero.KeyFingerMatchTest do
  use ExUnit.Case
  alias Typehero.KeyFingerMatch
  doctest Typehero.KeyFingerMatch

  test "it returns :match if key pressed with right finger" do
    assert KeyFingerMatch.match(9, "q") == :match
  end

  test "it returns :dismatch if key pressed with wrong finger" do
    assert KeyFingerMatch.match(8, "q") == :dismatch
  end
end
