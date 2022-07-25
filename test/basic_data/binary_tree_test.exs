defmodule BasicData.BinaryTreeTest do
  use ExUnit.Case, async: true

  alias BasicData.BinaryTree

  describe "new/1" do
    test "returns single node from list with one element" do
      assert %BinaryTree{value: 1} = BinaryTree.new([1])
    end

    test "with two elements, adds a left node" do
      assert %BinaryTree{value: 1, left: left} = BinaryTree.new([1, 2])
      assert %BinaryTree{value: 2} = left
    end

    test "with three elements, adds a left and right node" do
      assert %BinaryTree{value: 1, left: left, right: right} = BinaryTree.new([1, 2, 3])
      assert %BinaryTree{value: 2, left: nil, right: nil} = left
      assert %BinaryTree{value: 3, left: nil, right: nil} = right
    end

    test "creates a tree with only right child" do
      assert %BinaryTree{value: 1, right: %BinaryTree{value: 2}} = BinaryTree.new([1, nil, 2])
    end

    test "creates left granchildren" do
      list = [1, 2, 3, 4, 5, nil, nil]

      assert %{value: 1, left: %{value: 2, left: %{value: 4}, right: %{value: 5}}} =
               BinaryTree.new(list)
    end

    test "does not create nodes with nil values when creating right sided tree with nils in list" do
      list = [1, nil, 3, nil, nil, 6, 7]

      assert %{
               value: 1,
               left: nil,
               right: %{
                 value: 3,
                 left: %{value: 6},
                 right: %{value: 7}
               }
             } = BinaryTree.new(list)
    end

    test "creates right granchildren" do
      list = [1, 2, 3, 4, 5, 6, 7]

      assert %{value: 1, right: %{value: 3, left: %{value: 6}, right: %{value: 7}}} =
               BinaryTree.new(list)
    end

    test "works for a complex tree" do
      list = [1, 2, 3, nil, 5, 6, 7, nil, nil, 10, 11, 12, 13, 14, 15]

      assert %{right: %{value: 3, right: %{value: 7, right: %{value: 15}}}} = BinaryTree.new(list)
    end
  end

  describe "to_list" do
    test "nil produces empty list" do
      assert [] = BinaryTree.to_list(nil)
    end

    test "a single node without children returns a singleton list" do
      assert [6] = BinaryTree.to_list(BinaryTree.new([6]))
    end

    test "node with two children returns list of three" do
      list = [1, 2, 3]

      tree = BinaryTree.new(list)

      assert list == BinaryTree.to_list(tree)
    end

    @tag :skip
    test "with an longer sequence" do
      list = [1, nil, 3, nil, nil, 6, nil, nil, nil, nil, nil, 12, 13]

      tree = BinaryTree.new(list)

      assert list == BinaryTree.to_list(tree)
    end
  end

  describe "bfs" do
    @bfs_functions [&BinaryTree.bfs/1, &BinaryTree.bfs2/1, &BinaryTree.bfs3/1]

    test "returns root when tree has no children" do
      Enum.map(@bfs_functions, fn bfs ->
        result = BinaryTree.new([1]) |> bfs.()

        assert [1] = BinaryTree.new([1]) |> bfs.(),
               "Expected #{inspect(bfs)}([1]) to equal [1] but got #{result}"
      end)
    end

    test "returns children after root in 2-level tree" do
      Enum.map(@bfs_functions, fn bfs ->
        list = [1, 2, 3]
        result = BinaryTree.new(list) |> bfs.()

        assert list == result,
               "Expected #{inspect(bfs)}([1, 2, 3]) to equal [1, 2, 3] but got #{inspect(result)}"
      end)
    end

    test "handles height 3 tree" do
      Enum.map(@bfs_functions, fn bfs ->
        list = [1, 2, 3, 4, 5, 6, 7]
        result = BinaryTree.new(list) |> bfs.()

        assert(
          list == result,
          "Expected #{inspect(bfs)}(#{list}) to equal #{inspect(list)} but got #{inspect(result)}"
        )
      end)
    end

    test "handles left-heavy tree" do
      Enum.map(@bfs_functions, fn bfs ->
        list = [1, 2, nil, 4, 5, nil, nil]
        expected = list |> Enum.filter(& &1)

        result = BinaryTree.new(list) |> bfs.()

        assert expected == result,
               "Expected #{inspect(bfs)}(#{inspect(list)}) to equal #{inspect(expected)} but got #{result}"
      end)
    end

    test "handles right-heavy tree" do
      Enum.map(@bfs_functions, fn bfs ->
        list = [1, nil, 2, nil, nil, nil, 7]
        expected = list |> Enum.filter(& &1)

        result = BinaryTree.new(list) |> bfs.()

        assert expected == result,
               "Expected #{inspect(bfs)}(#{inspect(list)}) to equal #{inspect(expected)}"
      end)
    end
  end
end
