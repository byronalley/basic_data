defmodule BasicData.ArrayTest do
  use ExUnit.Case, async: true

  alias BasicData.Array

  describe "new/1" do
    test "without arguments, returns an empty array" do
      assert %Array{array: array} = Array.new()

      assert [] = array |> :array.to_list()
    end

    test "given a list, creates an array from it" do
      assert %Array{array: array} = Array.new([1, 2, 3])
      assert [1, 2, 3] = :array.to_list(array)
    end
  end

  describe "to_list/1" do
    test "given an empty array, returns []" do
      assert [] = Array.new() |> Array.to_list()
    end

    test "returns the contents of an array" do
      assert [1, 2, 3] = Array.new([1, 2, 3]) |> Array.to_list()
    end
  end
end
