defmodule SpellriderTest do
  use ExUnit.Case
  doctest Spellrider

  test "greets the world" do
    assert Spellrider.hello() == :world
  end
end
