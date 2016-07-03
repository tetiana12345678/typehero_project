defmodule TypeheroTest do
  use ExUnit.Case
  doctest Typehero

  test "#check_key returns correct response" do
    {:ok, pid} = Typehero.start_game("OK")
    assert Typehero.check_key(pid, ?O) == :ok
    assert Typehero.check_key(pid, ?P) == :error
    assert Typehero.check_key(pid, ?K) == :finish
  end
end
