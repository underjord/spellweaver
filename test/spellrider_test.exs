defmodule SpellweaverTest do
  use ExUnit.Case
  doctest Spellweaver

  test "greets the world" do
    assert Spellweaver.hello() == :world
  end
end
