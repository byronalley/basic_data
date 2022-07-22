defmodule BasicDataTest do
  use ExUnit.Case
  doctest BasicData

  test "greets the world" do
    assert BasicData.hello() == :world
  end
end
